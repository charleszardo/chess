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

  #move symbols to each class
  #method should return appropriate color
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

  #finish implmting
  def dup
  end

  def moves
    # to be implemented in subclasses
  end

  def valid_moves
    self.moves.reject do |move|
      test_board = self.board.dup
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
  ORTHOGONALS = [[0, -1],[-1, 0],[1, 0],[0, 1]]

  def move_dir(dir)
    end_positions = []
    x, y = self.pos
    dx, dy = dir
    not_killed = true
    while not_killed
      new_pos = [x + dx, y + dy]
      if self.board.legal_move?(new_pos, self.color)
        (not_killed = false) if self.board.kill_move?(new_pos, self.color)
        end_positions << new_pos
      else
        not_killed = false
        break
      end
      x, y = new_pos
    end
    end_positions
  end

  def setup_deltas
    @deltas = DIAGONALS + ORTHOGONALS
  end


  def moves
    self.setup_deltas
    @deltas.map{ |pos| move_dir(pos) }.flatten(1)
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
  end

end

class Queen < SlidingPiece

end

class Bishop < SlidingPiece
  def setup_deltas
    @deltas = DIAGONALS
  end
end

class Rook < SlidingPiece
  def setup_deltas
    @deltas = ORTHOGONALS
  end
end

class Knight < SteppingPiece
  MOVES = [
    [2, -1], [2, 1],
    [-2, -1], [-2, 1],
    [-1, 2], [1, 2],
    [-1, -2], [1, -2]]
end

class King < SteppingPiece
  MOVES = [
    [-1, -1],[-1, 1],[1, -1],[1, 1],
    [0, -1],[-1, 0],[1, 0],[0, 1]
    ]
end

class Pawn < Piece
  attr_reader :charge, :kill_moves

  def initialize(board, pos, color)
    super(board, pos, color)
    setup_pawn_moves
  end

  def setup_pawn_moves
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
  end
end