class ComputerPlayer
  attr_reader :board
  def initialize(board, color)
    @board = board
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
    return max(boards.map{|board| step(board, player, turns - 1)})
  end

  def move
    #3 ply look ahead

    #ab prone

    #calculate board value at every step

    #randomly select if states are tied


  end

  def evaluate(board)
    return -inifinity if board.checkmate(self.color)
    board.army(:black).inject(values hash blah blah) + board.army(:white)
  end


end