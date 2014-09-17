# encoding: utf-8
require_relative "pieces"
require_relative "board"
require_relative "errors"
require "colorize"
require_relative "cursor"

class Game
  MOVELIST = ["up", "down", "left", "right"]
  attr_accessor :current_player

  def initialize
    @game_board = Board.new
    @turns = 1
    @players = [HumanPlayer.new(:white), HumanPlayer.new(:black)]
  end

  def play
    @current_player = @players[@turns]
    while !@game_board.checkmate?(current_player.color)
      @current_player = @players[(@turns + 1) % 2]
      begin
        system("clear")
        @game_board.render(current_player.color)
        player_move = current_player.play_turn
        if MOVELIST.include?(player_move.first)
          @game_board.cursor.move(player_move.first)
        else
          @game_board.user_move(player_move.first, player_move.last, @current_player.color)
          @turns += 1
        end
      rescue ChessError => e
        puts e.to_s
        retry
      end
    end
  end
end

class HumanPlayer
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def play_turn
    puts "Pick a move"
    gets.chomp.split(' ')
  end

end

if __FILE__ == $PROGRAM_NAME
  # game = Game.new
  # game.play
  board = Board.new
  board.user_move("b2","b4",:white)
  board.user_move("c7","c5",:black)
  board.cursor.position = [4,1]
  pawn =  board[[4,1]]
  p pawn.color
  p pawn.pos
  p pawn.charge
  p pawn.kill_moves
  board.user_move("b4","c5",:white)
  board.render(:white)
end