# Class for jump movement strategy
class Shooter::Jump
  def initialize(x, y)
    @time = 0
    @init_x = x
    @init_y = y
    @last_y = y
    @power = 200
  end

  def get_height(time_diff)
    @time += time_diff * 2
    @last_y = @init_y - (@power * @time - 90 * @time**2)
  end
end
