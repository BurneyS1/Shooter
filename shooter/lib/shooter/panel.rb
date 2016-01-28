require 'shooter/static_object'

# Panels to jump at to the level end
class Shooter::Panel < Shooter::StaticObject
  include Math
  attr_accessor :occupied
  def initialize(game, x, y, w)
    super(game, x, y, w, 10, 'lib/shooter/media/panel.png')
    @xscale = @w.to_f / 100
    @occupied = false
  end

  def draw
    @img.draw(@x, @y, 1, @xscale)
  end

  def right_under?(c)
    (c.y + c.h - @upper).abs < 1 && collides_h?(c)
  end

  def right_above?(c)
    (c.y - @lower).abs < 1 && collides_h?(c)
  end

  def update_delta(delta)
  end
end
