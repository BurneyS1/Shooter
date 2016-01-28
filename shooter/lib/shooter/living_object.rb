require 'shooter/game_object'

# Base class for every living object
class Shooter::LivingObject < Shooter::GameObject
  attr_reader :dir
  def initialize(game, x, y, w, h, dir, lives, img)
    super(game, x, y, w, h, nil)
    @anim = Gosu::Image.load_tiles(img, w, h)
    @dir = dir
    @x_off = 0
    @lives = lives
  end

  def hit
    @lives -= 1
    die if @lives < 0
  end

  def die
    @game.remove(self)
  end

  def recount_mid
    @sx = @x + @w / 2
    @sy = @y + @h / 2
  end

  def draw
    @anim[Gosu.milliseconds / 200 % @anim.size].draw(@x + @x_off, @y, 1, @dir)
  end
end
