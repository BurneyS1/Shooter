require 'shooter/fireball'
require 'shooter/living_object'

# Alien representation
class Shooter::Alien < Shooter::LivingObject
  include Math
  def initialize(game, floor)
    x = rand(floor.right - floor.left) + floor.left
    y = floor.upper - 80
    super(game, x, y, 100, 80, 1, 2, 'lib/shooter/media/alien_anim2.png')
    @floor = floor
    @reload_time = rand(2) + 3
    @hit_sound = Gosu::Sample.new('lib/shooter/media/alien_scream.wav')
  end

  def flip
    @x_off = @x_off == 0 ? @w : 0
    @dir *= -1
  end

  def update_delta(delta)
    @reload_time -= delta if @reload_time > 0
    move(delta)
    shoot
  end

  def hit
    super
    @hit_sound.play
  end

  def on_right_end?
    @x + @w > @floor.right && @dir == 1
  end

  def on_left_end?
    @x < @floor.left && @dir == -1
  end

  def move(delta)
    dist = 100 * delta
    @x += dist * @dir
    flip if on_left_end? || on_right_end?
  end

  def shoot
    return if @reload_time > 0
    startx = @dir == 1 ? @x + @w : @x
    @game.add_missile(Shooter::Fireball.new(startx, @y + 2, @dir))
    @reload_time = 2 + rand(3)
  end
end
