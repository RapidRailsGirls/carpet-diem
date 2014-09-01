require 'forwardable'

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