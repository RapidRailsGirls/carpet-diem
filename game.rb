require 'gosu'
WINDOW_HEIGHT = 768
WINDOW_WIDTH  = 1024

class Window < Gosu::Window
  NUM_TILES = 16
  TILE_COLS = 4
  INITIAL_Y = -300
  VELOCITY = 3

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
      Gosu::Image.new(self, "media/background.jpeg", true).extend(YAccessible)
    end
    @yplus = INITIAL_Y
  end

  def draw
    @carpet.draw
    @backgrounds.each_with_index do | bg, index |
      bg.y = (index / TILE_COLS) * bg.height + @yplus
      bg.draw((index % TILE_COLS) * bg.width, bg.y, 0)
    end
  end

  def update
    if button_down? Gosu::KbLeft
      @carpet.x = [@carpet.x - 3, -35].max
      @carpet.flip_left
    end
    if button_down? Gosu::KbRight
      @carpet.x = [@carpet.x + 3, 930].min
      @carpet.flip_right
    end
    scroll_background
  end

  def scroll_background
    bg = @backgrounds.last
    if bg.y >= ((NUM_TILES / TILE_COLS) - 1) * bg.height - VELOCITY
      @yplus = INITIAL_Y
    else
      @yplus += VELOCITY
    end
  end
end

class Carpet

  attr_accessor :x

  def initialize(window)
    @image = @image_right = Gosu::Image.new(window, "media/carpet.png")
    @image_left = Gosu::Image.new(window, "media/carpet_flipped.png")
    @x = WINDOW_WIDTH/2 - @image.width/2
    @y = WINDOW_HEIGHT/1.4 - @image.height/2
  end
  
  def draw
    @image.draw(@x, @y, 1)
  end

  def flip_left
    @image = @image_left
  end

  def flip_right
    @image = @image_right
  end

end

window = Window.new
window.show
