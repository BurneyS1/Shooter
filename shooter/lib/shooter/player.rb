require 'shooter/jump'
require 'shooter/fall'
require 'shooter/living_object'
require 'shooter/health'

# Representation of the player himself
class Shooter::Player < Shooter::LivingObject
  def initialize(game)
    super(game, 0, game.floor - 80, 52, 80, 1, 3, 'lib/shooter/media/runner.png')
    init_states
    @speed = 170
    @upper_limit = -1
    @lower_limit = -1
    @weapon = nil
    @health = Shooter::Health.new(3)
    @die_sound = Gosu::Sample.new('lib/shooter/media/death.wav')
    @hit_sound = Gosu::Sample.new('lib/shooter/media/player_hit.wav')
    recount_mid
  end

  def init_states
    @running = false
    @jumping = false
    @falling = false
    @jump = nil
    @fall = nil
  end

  def update_delta(delta)
    move(delta)
    jump(delta)
    fall(delta)
    shoot
    check_collisions

    check_upper
    recount_mid
  end

  def move(delta)
    distance = delta * @speed
    if Gosu.button_down? Gosu::KbLeft
      @x -= distance if @x - distance >= 0
      @x_off = @w if @dir == 1
      @dir = -1
      @running = true
    elsif Gosu.button_down? Gosu::KbRight
      @x += distance if @x + distance + @w <= @game.w
      @x_off = 0 if @dir == -1
      @dir = 1
      @running = true
    else
      @running = false
    end
  end

  def jump(delta)
    if Gosu.button_down? Gosu::KbUp
      unless @jumping
        @jump = Shooter::Jump.new(@x, @y)
        @jumping = true
      end
    end
    return unless @jumping
    newy = @jump.get_height(delta)
    if newy >= @upper_limit
      @y = newy
    else
      @falling = true
      @jumping = false
    end
  end

  def fall(delta)
    if @falling
      @fall = Shooter::Fall.new(@x, @y) if @fall.nil?
      @y = @fall.get_height(delta)
    else
      @fall = nil
    end
  end

  def shoot
    return if @weapon.nil?
    @weapon.shoot if Gosu.button_down? Gosu::KbSpace
  end

  def hit
    super
    @health.decrease
    @hit_sound.play
  end

  def die
    @die_sound.play
    @game.lose
  end

  def equip_weapon(w)
    @weapon = w
    w.set_owner(self)
  end

  def check_collisions
    col = @game.collides_with_panel(self)
    if col.nil?
      @lower_limit = -1
      @falling = true unless @jumping
    else
      check_collision_h(col)
      check_collision_v(col) if col.collides_h?(self)
    end
  end

  def check_collision_v(col)
    if @sy > col.sy
      @upper_limit = col.lower
      check_upper
    else
      @lower_limit = col.upper - @h
      check_lower
      @falling = false
      @jumping = false
    end
  end

  def check_collision_h(col)
    return unless @y < col.upper && (@y + @h) > col.lower
    @x = @sx > col.sx ? (col.right + 1) : (col.left - @w - 1)
  end

  def draw
    if @running
      @anim[Gosu.milliseconds / @speed % @anim.size].draw(@x + @x_off, @y, 1, @dir)
    else
      @anim[0].draw(@x + @x_off, @y, 1, @dir)
    end
    @health.draw
  end

  def check_upper
    return if @upper_limit < 0
    @y = @upper_limit if @y < @upper_limit
    @upper_limit = -1 if @y > @upper_limit
  end

  def check_lower
    @y = @lower_limit if @lower_limit >= 0 && @y > @lower_limit
  end
end
