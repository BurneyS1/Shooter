require 'shooter/bullet'

# Weapon for player, shooting Bullets
class Shooter::Weapon < Shooter::GameObject
  def initialize(game, x, y)
    super(game, x, y, 25, 10, 'lib/shooter/media/gun.png')
    @owner = nil
    @dir = 1
    @shooting_sound = Gosu::Sample.new('lib/shooter/media/gunshot.wav')
    @reload_sound = Gosu::Sample.new('lib/shooter/media/reload.wav')
    @reload_time = 0
  end

  def is_owned
    !@owner.nil?
  end

  def set_owner(owner)
    @owner = owner
    @dir = @owner.dir
    update_x
    update_y
  end

  def update_x
    @x = @owner.dir == 1 ? @owner.x + 44 : @owner.x + 10
  end

  def update_y
    @y = @owner.y + 37
  end

  def shoot
    @reload_sound.play if @reload_time <= 0
    return if @reload_time > 0
    startx = @dir == 1 ? @x + @w : @x - @w
    @game.add_missile(Shooter::Bullet.new(startx, @y + 2, @dir))
    @reload_time = 1
    @shooting_sound.play
  end

  def can_pick_up?(p)
    @x >= p.x && @x <= p.x + p.w
  end

  def update_delta(delta)
    @reload_time -= delta if @reload_time > 0
    return if @owner.nil?
    @dir = @owner.dir
    update_x
    update_y
  end

  def draw
    @img.draw(@x, @y, 1, @dir)
  end
end
