# encoding: utf-8
require_relative "pieces"
require_relative "board"

class Game

end



class HumanPlayer
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  # board.render
  # board.move_piece([7,3], [3,1])
  board.render
  pawn = board[[1,3]]
  p pawn.class
  p pawn.moves
  p pawn.valid_moves
  p "\u2713".encode
  k = King.new(board, [5,5], :white)
  p k.gen_symbol.encode
  board.render
end