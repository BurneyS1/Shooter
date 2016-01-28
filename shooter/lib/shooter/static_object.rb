require 'shooter/game_object'

# Steady game object
class Shooter::StaticObject < Shooter::GameObject
  attr_reader :left, :right, :upper, :lower
  def initialize(game, x, y, w, h, img)
    super(game, x, y, w, h, img)
    @left = @x
    @right = @x + @w
    @upper = @y
    @lower = @y + @h
  end

  def collides_h?(c)
    c.x.between?(@left, @right) || (c.x + c.w).between?(@left, @right)
  end

  def collides_v?(c)
    c.y.between?(@upper, @lower) || (c.y + c.h).between?(@upper, @lower)
  end
end
