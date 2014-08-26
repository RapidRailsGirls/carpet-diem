require 'gosu'

class Window < Gosu::Window

  def initialize
    super(1024, 768, false)
    @carpet = Carpet.new(self)
    @backgrounds = 25.times.collect { Gosu::Image.new(self, "media/background.jpeg") }
  end

  def draw
    @carpet.draw
    @backgrounds.each_with_index { | bg, index | bg.draw((index % 5) * 238, (index / 5) * 158, 0) }
  end

  def update

  end

end

class Carpet

  attr_accessor :x

  def initialize(window)
    @image = Gosu::Image.new(window, "media/carpet.png")
    @x = 1024/2 - 150/2
    @y = 768/2 - 192/2
  end
  
  def draw
    @image.draw(@x, @y, 1)
  end
end

window = Window.new
window.show
