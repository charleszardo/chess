class Board
  SIZE = 8

  OPP = {:white => :black,
         :black => :white}

  attr_accessor :current_unit

  attr_reader :grid, :cursor

  def self.make_grid
    Array.new(SIZE) { Array.new(SIZE) }
  end

  def initialize(blank=false)
    @grid = self.class.make_grid
    make_pieces unless blank
    @cursor = Cursor.new([0,0], [8,8])
    @current_unit = @cursor.position
    @grave_yard = []
  end

  def make_pieces
    royalties = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    royalties.each_with_index do |piece, i|
      piece.new(self, [0, i], :black)
      Pawn.new(self, [1,i], :black)
      Pawn.new(self, [SIZE - 2,i], :white)
      piece.new(self, [SIZE - 1, i], :white)
    end
    nil
  end

  def dup
    dupped_board = Board.new(true)
    self.grid.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        if cell.kind_of?(Piece)
          dupped_board[[i,j]] = cell.class.new(dupped_board, [i,j], cell.color)
          #dupped_board[[i,j]] = cell.dup(dupped_board)
        end
      end
    end
    dupped_board
  end

  def []=(pos, piece)
    self.grid[pos[0]][pos[1]] = piece
  end

  def [](pos)
    self.grid[pos[0]][pos[1]]
  end

  def on_board?(pos)
    [pos[0], pos[1]].all? {|x| (0...SIZE).include?(x)}
  end

  def has_piece?(pos)
    self[pos].kind_of?(Piece)
  end

  def legal_move?(pos, color)
    return false unless self.on_board?(pos)
    self.has_piece?(pos) ? kill_move?(pos, color) : true
  end

  def kill_move?(pos, color)
    self.has_piece?(pos) && (self[pos].color != color)
  end

  def in_check?(color)
    throne = king_pos(color)
    self.army(OPP[color]).each do |unit|
      return true if unit.moves.include?(throne)
    end
    false
  end

  def checkmate?(color)
    self.in_check?(color) && self.army(color).all?{|unit| unit.valid_moves.empty?}
  end

  def king_pos(color)
    self.army(color).select {|unit| unit.is_a?(King)}.first.pos
  end

  def army(color)
    self.grid.flatten.select {|unit| !unit.nil? && unit.color == color}
  end

  def render(color = :white)
    print "| |"
    ("a".."h").each{|letter| print "|#{letter}|"}
    print "\n"
    i = 8
    color_counter = 0
    self.current_unit = self[self.cursor.position]
    if !self.current_unit.nil? && self.current_unit.color == color
      move_grid = self.current_unit.valid_moves
    else
      move_grid = []
    end

    @grid.each_with_index do |row, row_idx|
      print "|#{i}|"
      i -= 1
      row.each_with_index do |cell, col_idx|
        tile = cell.kind_of?(Piece) ? "|#{cell.gen_symbol.encode}|" : "| |"
        if [row_idx, col_idx] == self.cursor.position
          print tile.on_green.blink
        elsif move_grid.include?([row_idx, col_idx])
          print tile.on_yellow
        elsif color_counter % 2 == 0
          print tile.on_white
        else
          print tile.on_light_black
        end
        color_counter += 1
      end
      color_counter += 1
      print "\n"
    end
    false
  end

  def move_piece!(from_pos, to_pos)
    self[to_pos] = nil if self[to_pos].kind_of?(Piece)
    #update piece's position
    self[from_pos].pos = to_pos
    self[from_pos], self[to_pos] = self[to_pos], self[from_pos]
    self
  end

  def move_conversion(pos)
    pos = pos.split('')
    cols = ("a".."h").to_a
    rows = (1..8).to_a.reverse
    return [rows.index(pos.last.to_i), cols.index(pos.first)]
  end

  def move_piece(from_pos, to_pos)
    raise ChessError.new "There is no piece there" unless self[from_pos].kind_of?(Piece)
    raise ChessError.new "Not a valid move" unless self[from_pos].moves.include?(to_pos)
    raise ChessError.new "It Would Leave you in check" unless self[from_pos].valid_moves.include?(to_pos)
    if self[to_pos].kind_of?(Piece)
      @grave_yard << self[to_pos]
      self[to_pos] = nil
    end
    #update piece's position
    self[from_pos].pos = to_pos
    self[from_pos], self[to_pos] = self[to_pos], self[from_pos]
    self
  end

  def user_move(from_string, to_string, color)
    from_pos = self.move_conversion(from_string)
    to_pos = self.move_conversion(to_string)
    
    raise ChessError.new "Move your own piece, thief!" unless     self[from_pos].color == color
    self.move_piece(from_pos, to_pos)
  end
  
  def inspect
    self.render(:white)
    "Just Another Nameless Board"
  end
end
