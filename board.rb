class Board
  SIZE = 8

  OPP = {:white => :black,
         :black => :white}

  attr_reader :grid

  def self.make_grid
    Array.new(SIZE) { Array.new(SIZE) }
  end


  def initialize
    @grid = self.class.make_grid
    make_pieces
    # make_pieces
    # Pic Player Start or something like that
  end


  def make_pieces
    royalties = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    royalties.each_with_index do |piece, i|
      piece.new(self, [0, i], :black)
      Pawn.new(self, [1,i], :black)
      Pawn.new(self, [SIZE - 2,i], :white)
      piece.new(self, [SIZE - 1, i], :white)
    end
  end


  def deep_dup
    dupped_board = self.class.make_grid
    self.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        if cell.kind_of?(Piece)
          dupped_board[i,j] = cell.class.new(dupped_board, [i,j], cell.color)
        end
      end
    end
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
    kill_move?(pos, color)
  end

  def kill_move?(pos, color)
    self.has_piece?(pos) && (self[pos].color != color)
  end

  def in_check?(color)
    throne = king_pos(color)
    self.army(OPP[color]).each do |unit|
      # p unit.class
      # p unit.pos
      # p unit.moves
      #p throne
      #p unit.moves if unit.pos == [6,1]
      return true if unit.moves.include?(throne)
    end
    false
  end

  def king_pos(color)
    self.army(color).select {|unit| unit.is_a?(King)}.first.pos
  end

  def army(color)
    self.grid.flatten.select {|unit| !unit.nil? && unit.color == color}
  end

  def render
    @grid.each do |row|
      row.each do |cell|
        cell.kind_of?(Piece) ? print("|#{cell.crest}|") : print("| |")
      end
      print "\n"
    end
  end

  def move_piece(from_pos, to_pos)

    # TO BE REFACTORED!
    # begin
    #   raise ArgumentError.new "There is no piece there" unless self[from_pos].kind_of?(Piece)
    #   raise ArgumentError.new "Not a valid move" unless self[from_pos].moves.include?(to_pos)
    # rescue ArgumentError => e
    #   puts e.to_s
    #   retry
    # end

    self[from_pos].pos = to_pos
    self[from_pos], self[to_pos] = self[to_pos], self[from_pos]
  end

end
