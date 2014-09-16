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
    self[pos].is_a?(Piece)
  end

  def legal_move?(pos)
    self.on_board?(pos) && !self.has_piece?(pos)
  end

end

class Game

end

class Piece
  attr_accessor :pos

  attr_reader :color, :board

  MOVES = {diagonal: [],
            vertical: [],
            horizontal: [],
            lshape: []
            }

  def initialize(board, pos, color)
    @board = board
    self.pos = pos
    @color = color
  end

  def moves
    # to be implemented in subclasses
  end
end

class SlidingPiece < Piece
  DIAGONALS = [[-1, -1],[-1, 1],[1, -1],[1, 1]]
  STRAIGHTS = [[0, -1],[-1, 0],[1, 0],[0, 1]]
  def initialize()

  end

  def move_dir(dx, dy)
    end_positions = []
    x, y = self.pos

    while true
      new_pos = [x + dx, y + dy]
      if self.board.legal_move?(new_pos)
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
    moves << DIAGONALS.each{ |pos| move_dir(pos) }
    moves << STRAIGHTS.each{ |pos| move_dir(pos) }
    moves
  end
end

class SteppingPiece < Piece

end

class Bishop < SlidingPiece
end

class Knight < SteppingPiece
end

class HumanPlayer
end