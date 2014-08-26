require 'gosu'

class Window < Gosu::Window

  def initialize
    super(1024, 768, false)
    @carpet = Carpet.new(self)
  end

  def draw
    @carpet.draw
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
    @image.draw(@x, @y, 0)
  end
end

window = Window.new
window.show
