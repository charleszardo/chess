class Board
  SIZE = 8

  OPP = {:white => :black,
         :black => :white}

  attr_reader :grid

  def self.make_grid
    Array.new(SIZE) { Array.new(SIZE) }
  end

  def initialize(blank=false)
    @grid = self.class.make_grid
    make_pieces unless blank
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

  def render
    print "| |"
    ("a".."h").each{|letter| print "|#{letter}|"}
    print "\n"
    i = 8
    @grid.each do |row|

      print "|#{i}|"
      i -= 1
      row.each do |cell|
        cell.kind_of?(Piece) ? print("|#{cell.gen_symbol.encode}|") : print("| |")
      end
      print "\n"
    end
    false
  end

  def move_piece!(from_pos, to_pos)
    self[from_pos].pos = to_pos
    self[from_pos], self[to_pos] = self[to_pos], self[from_pos]
    self
  end

  def move_conversion(pos)
    pos = pos.split('')
    cols = ("a".."h").to_a
    rows = (1..8).to_a.reverse
    p pos
    p rows.index(pos.last.to_i)
    p cols.index(pos.first)
    return [rows.index(pos.last.to_i), cols.index(pos.first)]
  end

  def move_piece(from_pos, to_pos)
    # TO BE REFACTORED!
    # begin
    # subclass own error class, can inherit from AE
    raise ArgumentError.new "There is no piece there" unless self[from_pos].kind_of?(Piece)
    raise ArgumentError.new "Not a valid move" unless self[from_pos].moves.include?(to_pos)
    #puts "#{self[from_pos].valid_moves} CHECKIN"
    raise ArgumentError.new "It Would Leave you in check" unless self[from_pos].valid_moves.include?(to_pos)
    # rescue ArgumentError => e
    #   puts e.to_s
    #   retry
    # end

    self[from_pos].pos = to_pos
    self[from_pos], self[to_pos] = self[to_pos], self[from_pos]
    self
  end

  def user_move(from_string, to_string, color)
    from_pos = self.move_conversion(from_string)
    to_pos = self.move_conversion(to_string)
    raise ChessError.new "Move your own piece, thief!" unless self[from_pos].color == color
    self.move_piece(from_pos, to_pos)
  end
end
