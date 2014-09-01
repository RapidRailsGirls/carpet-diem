require 'forwardable'

class Carpet
  extend Forwardable
  def_delegators :@carpet_image, :height, :width
  attr_accessor :x, :y

  def initialize(window)
    @carpet_image = @carpet_image_right = Gosu::Image.new(window, 'media/carpet.png')
    @carpet_image_left = Gosu::Image.new(window, 'media/carpet_flipped.png')
    @x = WINDOW_WIDTH/2 - @carpet_image.width/2
    @y = WINDOW_HEIGHT/1.4 - @carpet_image.height/2
  end

  def draw
    @carpet_image.draw(@x, @y, 4)
  end

  def move_left(speed)
    @x = [@x - speed, 0 - @carpet_image.height / 4].max
    @carpet_image = @carpet_image_left
  end

  def move_right(speed)
    @x = [@x + speed, WINDOW_WIDTH - @carpet_image.height / 2].min
    @carpet_image = @carpet_image_right
  end

  def collides_with?(lamp)
    Gosu.distance(@x + @carpet_image.width/2, @y + @carpet_image.height/2, lamp.x + lamp.width/2, lamp.y + lamp.height/2) <= lamp.width
  end
end