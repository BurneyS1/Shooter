# Class for visual health representation
class Shooter::Health
  def initialize(count)
    @img = Gosu::Image.new('lib/shooter/media/heart.png')
    @w = 25
    @lives = count
  end

  def draw
    x = 0
    (0..@lives).each do
      @img.draw(x, 0, 1)
      x += @w
    end
  end

  def update_delta(delta)
  end

  def increase
    @lives += 1
  end

  def decrease
    @lives -= 1
  end
end
