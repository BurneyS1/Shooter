require 'shooter/missile'

# Bullet being shoot from a weapon
class Shooter::Bullet < Shooter::Missile
  attr_accessor :w, :h, :x, :y
  def initialize(x, y, dir)
    super(x, y, 3, 10, dir, 1000, 'lib/shooter/media/bullet.png')
  end

  def get_collision(game)
    game.aliens.each do |alien|
      return alien if collides_with?(alien)
    end
    nil
  end
end
