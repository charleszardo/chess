require_relative "pieces"
require_relative "board"

class Game

end



class HumanPlayer
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  board.render
  board.move_piece([0,4], [5,0])
  puts ""
  board.render
  p board.in_check?(:white)
  # [Knight].each do |i|
  #   i.new(board,[2,2], :white)
  # end
  #
  # #puts p.color
  #
  #
  #
  # piece = Pawn.new(board, [3,3], :white)
  # piece2 = King.new(board,[2,3], :white)
  # piece3 = Knight.new(board,[2,2], :white)
  # board[[2,2]] = piece3
  # board[[2,3]] = piece2
  # piece.moves
end