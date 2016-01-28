require 'shooter/missile'

# Missile type that aliens are shooting
class Shooter::Fireball < Shooter::Missile
  def initialize(x, y, dir)
    super(x, y, 60, 40, dir, 300, 'lib/shooter/media/fireball.png')
  end

  def get_collision(game)
    return game.player if collides_with?(game.player)
    nil
  end

  def collides_with?(o)
    (@x.between?(o.x, o.x + o.w) || (@sx).between?(o.x, o.x + o.w)) && (@y.between?(o.y, o.y + o.h) || (@y + @h).between?(o.y, o.y + o.h))
  end
end
