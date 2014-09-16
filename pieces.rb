# encoding: utf-8
class Piece
  attr_accessor :pos

  attr_reader :color, :board

  def initialize(board, pos, color)
    @board = board
    self.pos = pos
    @color = color
    board[pos] = self
  end

  def gen_symbol
    id = [self.color, self.class]
    symb_hash = {
      [:white, King] => "\u2654",
      [:white, Queen] => "\u2655",
      [:white, Rook] => "\u2656",
      [:white, Knight] => "\u2658",
      [:white, Bishop] => "\u2657",
      [:white, Pawn] => "\u2659",
      [:black, King] => "\u265A",
      [:black, Queen] => "\u265B",
      [:black, Rook] => "\u265C",
      [:black, Knight] => "\u265E",
      [:black, Bishop] => "\u265D",
      [:black, Pawn] => "\u265F"
    }
    symb_hash[id]
  end

  def dup
    Piece.new()
  end

  def moves
    # to be implemented in subclasses
  end

  def valid_moves
    self.moves.reject do |move|
      test_board = self.board.deep_dup
      test_board.move_piece!(self.pos, move).in_check?(self.color)
    end
  end

  def test_move(moves)
    d = Array.new(8) {Array.new(8)}
    8.times do |i|
      8.times do |j|
        if [i,j] == self.pos
          print("|S|")
        elsif self.board[[i,j]].kind_of?(Piece)
          print("|K|")
        elsif moves.include?([i,j])
          print("|X|")
        else
          print("| |")
        end
      end
      print "\n"
    end
  end

end

class SlidingPiece < Piece
  DIAGONALS = [[-1, -1],[-1, 1],[1, -1],[1, 1]]
  STRAIGHTS = [[0, -1],[-1, 0],[1, 0],[0, 1]]
  # def initialize()
  #
  # end

  def move_dir(dir)
    end_positions = []
    x, y = self.pos
    dx, dy = dir

    while true
      new_pos = [x + dx, y + dy]
      if self.board.legal_move?(new_pos, self.color)
        end_positions << new_pos
      else
        break
      end
      x, y = new_pos
    end
    end_positions
  end

  def moves
    moves = []
    moves += self.class::DIAGONALS.map{ |pos| move_dir(pos) }.flatten(1)
    moves += self.class::STRAIGHTS.map{ |pos| move_dir(pos) }.flatten(1)
  end


end

class SteppingPiece < Piece
  MOVES = []

  def moves
    x, y = self.pos
    moves = []
    self.class::MOVES.each do |dx, dy|
      x, y = x + dx, y + dy
      moves << [x, y] if self.board.legal_move?([x, y],self.color)
      x, y = self.pos
    end
    moves
    #self.test_move(moves)
  end

end

class Queen < SlidingPiece
  def crest
    "Q"
  end
end

class Bishop < SlidingPiece
  STRAIGHTS = []
  def crest
    "B"
  end
end

class Rook < SlidingPiece
  DIAGONALS = []
  def crest
    "R"
  end
end

class Knight < SteppingPiece
  MOVES = [
    [2, -1], [2, 1],
    [-2, -1], [-2, 1],
    [-1, 2], [1, 2],
    [-1, -2], [1, -2]]
    def crest
      "H"
    end
end

class King < SteppingPiece
  MOVES = [
    [-1, -1],[-1, 1],[1, -1],[1, 1],
    [0, -1],[-1, 0],[1, 0],[0, 1]
    ]
    def crest
      "K"
    end
end

class Pawn < Piece
  attr_reader :charge, :kill_moves

  def initialize(board, pos, color)
    super(board, pos, color)
    pawn_moves
  end

  def pawn_moves
    if self.color == :white
      @charge = [-1, 0]
      @kill_moves = [[-1, -1], [-1, 1]]
    else
      @charge = [ 1, 0]
      @kill_moves = [[ 1, -1], [ 1, 1]]
    end
  end

  def moves
    x, y = self.pos

    dx, dy = self.charge
    new_pos = [x + dx, y + dy]
    if self.board.legal_move?(new_pos, self.color)
      unless self.board.has_piece?(new_pos)
        moves = [new_pos]
      end
    end

    moves ||= []

    self.kill_moves.each do |dx, dy|
      x, y = x + dx, y + dy
      moves << [x, y] if self.board.kill_move?([x, y], self.color)
      x, y = self.pos
    end
    moves
    #self.test_move(moves)
  end
  def crest
    "P"
  end
end