require 'shooter/game_object'

# Base class for every type of missile
class Shooter::Missile < Shooter::GameObject
  attr_accessor :x, :y
  def initialize(x, y, w, h, dir, speed, img)
    super(game, x, y, w, h, img)
    @dir = dir
    @speed = speed
    @time = 0
    @init_x = x
    @sx = @x + @w / 2
    @sy = @y + @h / 2
  end

  def update_delta(delta)
    @time += delta
    @x = @init_x + @speed * @time * @dir
    recount_mid
  end

  def recount_mid
    @sx = @x + @w / 2
  end

  def draw
    @img.draw(@x, @y, 1, @dir)
  end

  def get_collision(game)
    nil
  end
end
