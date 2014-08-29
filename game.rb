require 'gosu'
WINDOW_HEIGHT = 768
WINDOW_WIDTH  = 1024

class Window < Gosu::Window
  NUM_TILES = 16
  TILE_COLS = 4
  INITIAL_Y = -300
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
      Gosu::Image.new(self, "media/background.jpeg", true).extend(YAccessible)
    end
    @yplus = INITIAL_Y
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
      @carpet.x = [@carpet.x - CARPET_SPEED, -35].max
      @carpet.flip_left
    end
    if button_down? Gosu::KbRight
      @carpet.x = [@carpet.x + CARPET_SPEED, 930].min
      @carpet.flip_right
    end
    scroll_background
    if @counter % 60 == 0
      @lamps.push LampWithGenie.new(self)
    end
    scroll_lamps
    if @lamps.any? do |lamp|
      if @carpet.collides_with?(lamp)
        lamp.z_genie = 3
      end
    end
  end

  end

  def scroll_background
    bg = @backgrounds.last
    if bg.y >= ((NUM_TILES / TILE_COLS) - 1) * bg.height - VELOCITY
      @yplus = INITIAL_Y
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

  attr_accessor :x, :y

  def initialize(window)
    @image = @image_right = Gosu::Image.new(window, "media/carpet.png")
    @image_left = Gosu::Image.new(window, "media/carpet_flipped.png")
    @x = WINDOW_WIDTH/2 - @image.width/2
    @y = WINDOW_HEIGHT/1.4 - @image.height/2
  end

  def draw
    @image.draw(@x, @y, 4)
  end

  def flip_left
    @image = @image_left
  end

  def flip_right
    @image = @image_right
  end

  def collides_with?(lamp)
    Gosu::distance(@x/2, @y, lamp.x/2, lamp.y) <= 100
  end

end

class LampWithGenie
  attr_accessor :y, :x, :z_genie

  def initialize(window)
    @random_lamp = rand(2)
    if @random_lamp.odd?
      @lamp = Gosu::Image.new(window, "media/lamp.png")
      @genie = Gosu::Image.new(window, "media/good_genie.png")
    else
      @lamp = Gosu::Image.new(window, "media/lamp_flipped.png")
      @genie = Gosu::Image.new(window, "media/good_genie_flipped.png")
    end
    @x = rand(@genie.width/2..(WINDOW_WIDTH - @genie.width))
    @y = -@lamp.height
    @z_genie = 0
  end

  def draw
    @lamp.draw(@x, @y, 2)
    if @random_lamp.odd?
      @genie.draw(@x - 150, @y - 200, @z_genie)
    else
      @genie.draw(@x + 140, @y - 200, @z_genie)
    end
  end
end



window = Window.new
window.show
