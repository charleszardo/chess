class Cursor

  attr_accessor :position
  attr_reader   :width, :height
  def initialize(pos, grid)
    self.position = pos
    @height, @width = grid.first, grid.last
  end

  def move(dir)
    x, y = self.position.first, self.position.last
    case dir
    when "up"
      x =  self.cycle_pos((x - 1), @height)
    when "down"
      x = self.cycle_pos((x + 1), @height)
    when "left"
      y = self.cycle_pos((y - 1), @width)
    when "right"
      y = self.cycle_pos((y + 1), @width)
    end
    self.position = [x, y]
  end

  def cycle_pos(x, max)
    case
    when x >= max
      (max % x)
    when x < 0
      (max + x)
    else
      x
    end
  end

end