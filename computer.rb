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
  attr_reader :color, :recurse_level
  def initialize(color)
    @color = color
    @recurse_level = 1
  end

  def future_tree(board, future_level, color = self.color)
    # Generate An Array Of All Possible Moves
    return self.evaluate(board) if future_level < 0

    #Return If We've Found A Checkmate
    valid_steps = self.valid_steps(board, color)

    return self.evaluate(board) if valid_steps.empty?

    crystal_ball = valid_steps.map{|step| [step]}

    #this is to make sure we only go deeper when it's after opponents turn
    future_level -= 1 unless self.color == color

    crystal_ball.each do |time_shard|
      step_state = self.moved_state(board, time_shard.first)
      next_color = OPP[color]
      recurse = future_tree(step_state, future_level, next_color)
      time_shard << recurse
    end
    #future tree has the structure of [move, board, value, future_tree(lvl -1)]
    crystal_ball
  end

  def process_tree(future_tree, level)

    if level == self.recurse_level
      last_our_moves = future_tree.each do |our_turn|
        next unless our_turn[-1].is_a?(Array)
        #The Last Possible Enemy Moves

        our_turn[-1] = self.min_of_last_nodes(our_turn[-1])
      end
      our_max = max_of_last_nodes(last_our_moves)
      random_max = last_our_moves.select.select{|branch| branch.last == our_max}.sample
      p random_max

    else
      # This updates the nodes one level deep
      future_tree.each do |our_turn|
          next unless our_turn[-1].is_a?(Array)
        our_turn.each do |their_turn|
          next unless their_turn[-1].is_a?(Array)
          p their_turn if their_turn[-1] == [1,0]
          their_turn[-1] = self.process_tree(their_turn[-1], level + 1)
        end
      end

      # Returns The max value to be merged in
      future_tree_tree.each do |our_turn|
        next unless our_turn[-1].is_a?(Array)
        our_turn[-1] = self.min_of_last_nodes(our_turn[-1])
      end

      # Return last of our turns
      p  max_of_last_nodes(last_our_moves)
      max_of_last_nodes(last_our_moves)
    end

  end

  def max_of_last_nodes(nodes)
    # p nodes
    return nodes unless nodes.is_a?(Array)
    nodes.map{|node| node.last}.max
  end

  def min_of_last_nodes(nodes)
    return nodes unless nodes.is_a?(Array)
    #gets nodes, turn nodes into board values
    values = nodes.map do |node|
      node.last
    end
    # Returns Board Value Of Enemy Best Move
    values.min
  end

  def valid_steps(board, player)
    #Return an array of all possible valid from  -> to combos
    units = board.army(player)

    moves = units.map do |unit|
       unit.valid_moves.map do |move|
         [unit.pos, move]
     end
    end

    moves.flatten(1)
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
  Knight.new(board, [0,1], :black)
  Rook.new(board, [2,2], :white)  #
  # Knight.new(board, [2,1], :black)
  player = ComputerPlayer.new(:black)
  board.render(:black)
  start_time = Time.new  #
  future_sight = player.future_tree(board, 1) #
  #puts future_sight.first.first #this is the move from, to combo  #
  # puts future_sight.first[1] # This is the first level state, and only  only the  state
  # p future_sight.first.last.first #this is the second level item, two moves forward
  end_time = Time.new
  print "took #{end_time - start_time} seconds to generate future tree\n"
  # p future_sight.first.last
  player.process_tree(future_sight,0)
  # p future_sight.last[2]
  # Took 4.27 seconds with plain look ahead



end