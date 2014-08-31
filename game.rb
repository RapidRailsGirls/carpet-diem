require 'forwardable'
require 'gosu'

WINDOW_HEIGHT = 800
WINDOW_WIDTH  = 1200

class Window < Gosu::Window
  NUM_TILES = 6
  TILE_COLS = 2
  VELOCITY = 3
  CARPET_SPEED = 5

  module YAccessible
    attr_writer :y
    def y
      @y.to_i
    end
  end

  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT, false)
    @carpet = Carpet.new(self)
    @backgrounds = NUM_TILES.times.collect do
      Gosu::Image.new(self, 'media/background.jpg', true).extend(YAccessible)
    end
    @yplus = -@backgrounds.last.height
    @counter = 0
    @lamps = []
  end

  def draw
    @carpet.draw
    @backgrounds.each_with_index do | bg, index |
      bg.y = (index / TILE_COLS) * bg.height + @yplus
      bg.draw((index % TILE_COLS) * bg.width, bg.y, 1)
    end
    @lamps.each {|lamp| lamp.draw}
  end

  def update
    @counter += 1
    if button_down? Gosu::KbLeft
      @carpet.x = [@carpet.x - CARPET_SPEED, 0 - @carpet.height / 4].max
      @carpet.flip_left
    end
    if button_down? Gosu::KbRight
      @carpet.x = [@carpet.x + CARPET_SPEED, WINDOW_WIDTH - @carpet.height / 2].min
      @carpet.flip_right
    end
    scroll_background
    if @counter % 60 == 0
      @lamps.push LampWithGenie.new(self)
    end
    scroll_lamps
    @lamps.any? do |lamp|
      if @carpet.collides_with?(lamp)
        lamp.rubbed = true
      end
    end
  end

  def scroll_background
    bg = @backgrounds.last
    if bg.y >= ((NUM_TILES / TILE_COLS) - 1) * bg.height - VELOCITY
      @yplus = -bg.height
    else
      @yplus += VELOCITY - 1
    end
  end

  def scroll_lamps
    @lamps.each do |lamp|
      lamp.y += VELOCITY
    end
  end
end

class Carpet
  extend Forwardable
  def_delegators :@carpet, :height, :width
  attr_accessor :x, :y

  def initialize(window)
    @carpet = @carpet_right = Gosu::Image.new(window, 'media/carpet.png')
    @carpet_left = Gosu::Image.new(window, 'media/carpet_flipped.png')
    @x = WINDOW_WIDTH/2 - @carpet.width/2
    @y = WINDOW_HEIGHT/1.4 - @carpet.height/2
  end

  def draw
    @carpet.draw(@x, @y, 4)
  end

  def flip_left
    @carpet = @carpet_left
  end

  def flip_right
    @carpet = @carpet_right
  end

  def collides_with?(lamp)
    Gosu.distance(@x + @carpet.width/2, @y + @carpet.height/2, lamp.x + lamp.width/2, lamp.y + lamp.height/2) <= lamp.width
  end
end

class LampWithGenie
  extend Forwardable
  def_delegators :@lamp, :height, :width
  attr_accessor :rubbed, :x, :y
  alias :rubbed? :rubbed
  undef :rubbed

  def initialize(window)
    @scale = 0.0
    if flipped?
      @lamp = Gosu::Image.new(window, 'media/lamp_flipped.png')
      if good?
        @genie = Gosu::Image.new(window, 'media/good_genie_flipped.png')
      else
        @genie = Gosu::Image.new(window, 'media/evil_genie_flipped.png')
      end
    else
      @lamp = Gosu::Image.new(window, 'media/lamp.png')
      if good?
        @genie = Gosu::Image.new(window, 'media/good_genie.png')
      else
        @genie = Gosu::Image.new(window, 'media/evil_genie.png')
      end
    end
    @rubbed = false
    @x = rand(@genie.width/2..(WINDOW_WIDTH - @genie.width))
    @y = -@lamp.height
  end

  def good?
    if defined? @good
      return @good
    else
      @good = rand(2) == 0
    end
  end

  def evil?
    !good?
  end

  def flipped?
    if defined? @flipped
      return @flipped
    else
      @flipped = rand(2) == 0
    end
  end

  def draw
    @lamp.draw(@x, @y, 2)
    if rubbed?
      @scale += 0.03 if @scale <= 1
      if !flipped? && good?
        @genie.draw(@x - 150 * @scale, @y - 200 * @scale, 3, @scale, @scale)
      elsif !flipped? && evil?
        @genie.draw(@x - 150 * @scale, @y - 200 * @scale, 3, @scale, @scale)
      elsif flipped? && good?
        @genie.draw(@x + 150, @y - 200 * @scale, 3, @scale, @scale)
      elsif flipped? && evil?
        @genie.draw(@x + 120, @y - 200 * @scale, 3, @scale, @scale)
      end
    end
  end
end

window = Window.new
window.show
