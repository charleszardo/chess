class Board
  SIZE = 8

  attr_reader :grid

  def initialize
    make_grid
    # make_pieces
    # Pic Player Start or something like that
  end

  def make_grid
    @grid = Array.new(SIZE) { Array.new(SIZE) }
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
    self.on_board?(pos) || kill_move?(pos, color)
  end

  def kill_move?(pos, color)
    self.has_piece?(pos) && (self[pos].color != color)
  end

  def render
    @grid.each do |row|
      row.each do |cell|
        print "| |" unless cell.is_a?(Piece)
      end
      print "\n"
    end

  end

end

class Game

end

class Piece
  attr_accessor :pos

  attr_reader :color, :board

  def initialize(board, pos, color)
    @board = board
    self.pos = pos
    @color = color
  end

  def moves
    # to be implemented in subclasses
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
    self.test_move(moves)
  end


end

class SteppingPiece < Piece
  MOVES = []

  def moves
    x, y = self.pos
    moves = []
    p MOVES
    self.class::MOVES.each do |dx, dy|
      x, y = x + dx, y + dy
      moves << [x, y] if self.board.legal_move?([x, y],self.color)
      x, y = self.pos
    end
    self.test_move(moves)
  end

end

class Queen < SlidingPiece

end

class Bishop < SlidingPiece
  STRAIGHTS = []
end

class Rook < SlidingPiece
  DIAGONALS = []
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
    p moves
    self.test_move(moves)
  end
end

class HumanPlayer
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  piece = Pawn.new(board, [3,3], :white)
  piece2 = King.new(board,[2,3], :white)
  piece3 = Knight.new(board,[2,2], :white)
  board[[2,2]] = piece3
  board[[2,3]] = piece2
  piece.moves
end