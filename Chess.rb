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
    @turns += 1
    while true
      @current_player = @players[@turns % 2]
      break if @game_board.checkmate?(@current_player.color)
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
        print e.to_s
        retry
      end
    end
    self.game_over
  end

  def game_over
    system("clear")
    text = "
      _____          __  __ ______    ______      ________ _____  _
     / ____|   /\   |  \/  |  ____|  / __ \ \    / /  ____|  __ \| |
    | |  __   /  \  | \  / | |__    | |  | \ \  / /| |__  | |__) | |
    | | |_ | / /\ \ | |\/| |  __|   | |  | |\ \/ / |  __| |  _  /| |
    | |__| |/ ____ \| |  | | |____  | |__| | \  /  | |____| | \ \|_|
     \_____/_/    \_\_|  |_|______|  \____/   \/   |______|_|  \_(_)
 ________________________________________________________________________
|________________________________________________________________________|

    "
    print text.blink
    sleep (2)
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
  # board = Board.new
  # board.user_move("f2","f3",:white)
  # board.user_move("e7","e5",:black)
  # board.user_move("g2","g4",:white)
  # board.user_move("d8","h4",:black)
  # puts "black mate? #{board.checkmate?(:black)}"
  # puts "white mate? #{board.checkmate?(:white)}"
  # board.render(:white)
  # board.cursor.position = [0,1]
  # pawn =  board[[4,1]]
  # p pawn.color
  # p pawn.pos
  # p pawn.charge
  # p pawn.kill_moves
  # board.user_move("b4","c5",:white)
  # board.render(:white)
end