require 'rubygems'
require 'gosu'
require 'shooter/player'
require 'shooter/panel'
require 'shooter/door'
require 'shooter/weapon'
require 'shooter/missile'
require 'shooter/alien'

# The main game logic
class Shooter::Game < Gosu::Window
  attr_reader :w, :h, :aliens, :player
  PLAYING = 1
  LOST = 2
  WON = 3
  def initialize
    super(1300, 850, false)
    self.caption = 'Shooter'
    @w = 1300
    @h = 850

    @background = Gosu::Image.new(self, 'lib/shooter/media/background_blue.png')
    @win_sound = Gosu::Sample.new('lib/shooter/media/win.wav')
    @last_milliseconds = 0

    @player = Shooter::Player.new(self)
    @state = PLAYING
    @font = Gosu::Font.new(150)
    @panels = create_panels
    @door = create_door
    @weapons = create_weapons
    @missiles = []
    @aliens = create_aliens
    @components = [@door, @player, @aliens, @panels, @weapons].flatten
  end

  def draw
    @components.each { |c| c.draw }
    @font.draw('LEVEL COMPLETED!', 90, 350, 1) if @state == WON
    @font.draw('GAME OVER!', 240, 350, 1) if @state == LOST
    @background.draw(0, 0, 0)
  end

  def button_up(key)
    close if key == Gosu::KbEscape
  end

  def collides_with_panel(c)
    @panels.select { |x| Gosu.distance(c.sx, c.sy, x.sx, x.sy) < (c.h + x.w) }.each do |panel|
      return panel if panel.collides_with?(c)
    end
    nil
  end

  def create_panels
    panels = []
    level = @h - 110
    panels << create_lower_floor
    lvl = create_random_panels(level)
    panels << lvl
    level -= 100
    while level > @player.h
      lvl = create_panel_level(lvl, level)
      panels << lvl
      level -= 100
    end
    panels.flatten
  end

  def create_random_panels(level)
    panels = []
    x = 0
    while x <= @w - 200
      width = (rand(5) + 2) * 50 + 100
      width = 200 if x + width > @w
      panels << Shooter::Panel.new(self, x, level, width)
      x = panels.last.right + 55 + rand(40)
    end
    panels
  end

  def create_panel_left_from(pan, level)
    x = pan.left - rand(100)
    x = 0 if x < 0
    w = (rand(5) + 2) * 50 + 100
    w = pan.right - x - 60 if x + w >= pan.right
    w < 200 ? nil : Shooter::Panel.new(self, x, level, w)
  end

  def create_panel_right_from(pan, level)
    x = pan.left + 60 + rand(100)
    w = (rand(5) + 2) * 50 + 100
    w = @w - x if x + w >= @w
    w < 200 ? nil : Shooter::Panel.new(self, x, level, w)
  end

  def create_panel_level(last_level, level)
    panels = []
    last_level.each do |panel|
      if rand(2) == 0
        new = create_panel_left_from(panel, level)
        new = create_panel_right_from(panel, level) if new.nil?
      else
        new = create_panel_right_from(panel, level)
        new = create_panel_left_from(panel, level) if new.nil?
      end
      panels << new unless new.nil?
    end
    fix_overlaps(panels)
    panels.flatten
  end

  def fix_overlaps(panels)
    panels.each do |panel1|
      panels.each do |panel2|
        panels.delete(panel1) if panel1 != panel2 && panel1.collides_with?(panel2)
      end
    end
  end

  def create_lower_floor
    Shooter::Panel.new(self, 0, floor, @w)
  end

  def create_weapons
    Shooter::Weapon.new(self, 60, @h - 30)
  end

  def add_missile(missile)
    @missiles << missile
    @components << missile
  end

  def create_aliens
    aliens = []
    (0..10).each do
      free_panels = @panels.select { |p| !p.occupied }
      chosen_panel = free_panels[rand(free_panels.length)]
      aliens << Shooter::Alien.new(self, chosen_panel)
      chosen_panel.occupied = true
    end
    aliens
  end

  def create_door
    last_panel = @panels.last
    x = last_panel.x + last_panel.w - 55
    Shooter::Door.new(self, x, last_panel.upper - 100)
  end

  def update
    return unless @state == PLAYING
    update_delta
    if !@weapons.is_owned && @weapons.can_pick_up?(@player)
      @player.equip_weapon(@weapons)
    end
    check_missile_collisions
    delete_oor_missiles
    check_win
  end

  def check_win
    return unless @door.is_in?(@player)
    @state = WON
    @win_sound.play
  end

  def delete_oor_missiles
    @missiles.select { |missile| missile.x < 0 || missile.x > @w }.each do |missile|
      @missiles.delete(missile)
      @components.delete(missile)
    end
  end

  def check_missile_collisions
    @missiles.each do |missile|
      target = missile.get_collision(self)
      hit_target(target, missile) unless target.nil?
    end
  end

  def hit_target(target, missile)
    target.hit
    @missiles.delete(missile)
    @components.delete(missile)
  end

  def remove(obj)
    @components.delete(obj)
    @aliens.delete(obj)
  end

  def floor
    @h - 10
  end

  def lose
    @state = LOST
  end

  def update_delta
    current_time = Gosu.milliseconds / 1000.0
    @delta = [current_time - @last_milliseconds, 0.25].min
    @last_milliseconds = current_time
    @components.each { |c| c.update_delta(@delta) }
  end
end
