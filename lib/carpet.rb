require_relative 'positionable'

class Carpet
  include Positionable
  CARPET_SPEED = 5
  attr_reader :carpet_image
  alias :image :carpet_image
  undef :carpet_image

  def initialize(window, carpet_image_file = 'carpet.png', carpet_image_flipped_file = 'carpet_flipped.png')
    @carpet_image = @carpet_image_right = Gosu::Image.new('lib/media/' + carpet_image_file)
    @carpet_image_left = Gosu::Image.new('lib/media/' + carpet_image_flipped_file)
    @window = window
    @x = window.width/2.0 - @carpet_image.width/2.0
    @x += 1 if window.width.odd? && @carpet_image.width.odd?
    @y = window.height/(18/13.0) - @carpet_image.height/2.0
  end

  def draw(counter, score)
    if score > 3
      @carpet_image.draw(@x, @y, 4)
    elsif score > 0
      @z = counter % 20 == 1 ? 1 : 4
      @carpet_image.draw(@x, @y, @z)
    end
  end

  def move_left
    @x = [@x - CARPET_SPEED, 0 - @carpet_image.height / 4].max
    @carpet_image = @carpet_image_left
  end

  def move_right
    @x = [@x + CARPET_SPEED, @window.width - @carpet_image.height / 2].min
    @carpet_image = @carpet_image_right
  end

  def collides_with?(object)
    object.bottom  * object.scale > top    &&
      object.top                  < bottom &&
      object.right * object.scale > left   &&
      object.left                 < right
  end
end
