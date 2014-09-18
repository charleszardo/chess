#TO DO:

# Minimax

# AB Pruning

# Iterative Deepening

# Transposition Table??

require_relative "board"
require_relative "pieces"
require_relative "cursor"
require 'colorize'

class ComputerPlayer
  OPP = {white: :black,
       black: :white}
  VALUES = {
    "Queen" => 900,
    "Rook" => 500,
    "Knight" => 300, 
    "Bishop" => 325, 
    "Pawn" => 100,
    "King" => 0
  }
  attr_reader :color
  def initialize(color)
    @color = color
  end

  def step(board, player, turns)
    return evaluate(board) if turns == 0
    boards = []

      board.army(player.color).each do |unit|
        unit.valid_moves.each do |move|
          boards << boards.move(unit.from pos, move)
        end
      end

    #go through every possible moves of players units
    #dup board, gets N board. Each board has value of V
    #if my color is their color, choose one which gives max board position
    return max(boards.map{|board| step(board, player, turns - 1)}) if player.color = self.color
    #else return min of all boards
    return max(boards.map{|board| step(board, player, turns - 1)}) unless player.color = self.color
  end

  def move
    #3 ply look ahead

    #ab prone

    #calculate board value at every step

    #randomly select if states are tied


  end

  def evaluate(board)
    my_value = self.player_score(board, self.color)
    opp_value = self.player_score(board, OPP[self.color])
    my_value - opp_value
  end
  
  def player_score(board, color)
    return -20000 if board.checkmate?(color)
    army = board.army(color)
    army.inject(0) do |acc,unit|
       acc + VALUES[unit.class.to_s]
     end
  end

end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  player = ComputerPlayer.new(:white)
  board.render(:white)
  p player.evaluate(board)
  board[[0,1]] = nil
  p player.evaluate(board)
  
  
end