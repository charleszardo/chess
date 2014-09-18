#TO DO:

# Minimax

# AB Pruning

# Iterative Deepening

# Transposition Table??

require_relative "board"
require_relative "pieces"
require_relative "cursor"
require 'colorize'
require 'set'

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
  
  def future_tree(board, future_level, color = self.color)    #
    # Generate An Array Of All Possible Moves
    return self.evaluate(board) if future_level == 0 && color != self.color

    valid_steps = self.valid_steps(board, color)
    crystal_ball = valid_steps.map{|step| [step]}
    #this is to make sure we only go deeper when it's after opponents turn
    future_level -= 1 unless self.color == color
    
    crystal_ball.each do |time_shard|
      step_state = self.moved_state(board, time_shard.first)
      time_shard << step_state
      next_color = OPP[color]
      recurse = future_tree(step_state, future_level, next_color)
      time_shard << recurse
    end
    
    crystal_ball
  end
  
  def min_max
    # We Want To Maximize The Minimum Opponent Player Score

    
    # Our Step
    
    #Their Step
  end

  
  
  def valid_steps(board, player)
    #Return an array of all possible valid from  -> to combos 
    units = board.army(player)
    moves = units.map do |unit|
       unit.valid_moves.map do |move|
         [unit.pos, move]
     end
    end
    moves = moves.flatten(1)
  end
  
  def moved_state(board, step)
    #Get a new board state
      board.dup.move_piece!(step.first, step.last)
  end
  
  def state_scores(board_states)
    #Returns an array of board scores
    scores = board_states.map do |state|
      self.evaluate(state)
    end
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
  board = Board.new(true)
  King.new(board, [0,2], :white)
  King.new(board, [0,0], :black)
  Rook.new(board, [2,2], :white)
  player = ComputerPlayer.new(:white)
  board.render(:white)
  start_time = Time.new
  future_sight = player.future_tree(board, 2)  #
  #puts future_sight.first.first #this is the move from, to combo  #
  # puts future_sight.first[1] # This is the first level state, and only  only the  state
  # p future_sight.first.last.first #this is the second level item, two moves forward
  end_time = Time.new
  print "took #{end_time - start_time} seconds to generate future tree"
  # Took 4.27 seconds with plain look ahead
  
  
  
end