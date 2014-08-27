require 'gosu'
WINDOW_HEIGHT = 768
WINDOW_WIDTH  = 1024

class Window < Gosu::Window

  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT, false)
    @carpet = Carpet.new(self)
    @backgrounds = 25.times.collect { Gosu::Image.new(self, "media/background.jpeg", true) }
  end

  def draw
    @carpet.draw
    @backgrounds.each_with_index { | bg, index | bg.draw((index % 5) * bg.width, (index / 5) * bg.height, 0) }
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
  end

end

class Carpet

  attr_accessor :x

  def initialize(window)
    @image = @image_right = Gosu::Image.new(window, "media/carpet.png")
    @image_left = Gosu::Image.new(window, "media/carpet_flipped.png")
    @x = WINDOW_WIDTH/2 - @image.width/2
    @y = WINDOW_HEIGHT/2 - @image.height/2
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
