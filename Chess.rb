# encoding: utf-8
require_relative "pieces"
require_relative "board"
require_relative "errors.rb"

class Game
  attr_accessor :current_player

  def initialize
    @game_board = Board.new
    @turns = 1
    @players = [HumanPlayer.new(:white), HumanPlayer.new(:black)]
  end

  def play
    @current_player = @players[@turns]
    while !@game_board.checkmate?(current_player.color)
      @current_player = @players[(@turns += 1) % 2]
      begin
        system("clear")
        @game_board.render
        player_move = current_player.play_turn
        @game_board.user_move(player_move.first, player_move.last, @current_player.color)
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
  game = Game.new
  game.play
end