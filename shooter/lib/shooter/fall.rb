# Falling movement strategy
class Shooter::Fall
  def initialize(x, y)
    @time = 0
    @init_x = x
    @init_y = y
  end

  def get_height(time_diff)
    @time += time_diff * 2
    @init_y - (-90 * @time**2)
  end
end
