# Main class for every object in the game
class Shooter::GameObject
  attr_reader :game, :x, :y, :w, :h, :sx, :sy
  def initialize(game, x, y, w, h, img)
    @game = game
    @w = w
    @h = h
    @x = x
    @y = y
    @img = Gosu::Image.new(img) unless img.nil?
    @sx = @x + @w / 2
    @sy = @y + @h / 2
  end

  def collides_with?(o)
    collides_h?(o) && collides_v?(o) || o.collides_h?(self) && o.collides_v?(self)
  end

  def collides_h?(c)
    c.x.between?(@x, @x + @w) || (c.x + c.w).between?(@x, @x + @w)
  end

  def collides_v?(c)
    c.y.between?(@y, @y + @h) || (c.y + c.h).between?(@y, @y + @h)
  end

  def draw
    @img.draw(@x, @y, 1)
  end
end
