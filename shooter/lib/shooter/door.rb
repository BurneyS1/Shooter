require 'shooter/static_object'

# Door leading to level end
class Shooter::Door < Shooter::StaticObject
  attr_accessor :w, :h, :upper, :lower, :left, :right

  def initialize(game, x, y)
    super(game, x, y, 55, 100, 'lib/shooter/media/door.png')
    @left = @x
    @right = @x + @w
    @upper = @y
    @lower = @y + @h
  end

  def is_in?(c)
    c.x >= @left && c.x + c.w < @right && c.y >= @upper && c.y + c.h <= @lower
  end

  def update_delta(delta)
  end
end
