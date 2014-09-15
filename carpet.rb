require 'forwardable'
require 'texplay'
require 'chingu'

class Carpet
  extend Forwardable
  def_delegators :@carpet_image, :width, :height
  CARPET_SPEED = 5
  attr_accessor :x, :y
  attr_reader :carpet_image
  alias :image :carpet_image
  alias :left :x
  alias :top :y
  undef :carpet_image

  def initialize(window, carpet_image_file = 'media/carpet.png', carpet_image_flipped_file = 'media/carpet_flipped.png')
    @carpet_image = @carpet_image_right = Gosu::Image.new(window, carpet_image_file)
    @carpet_image_left = Gosu::Image.new(window, carpet_image_flipped_file)
    @window = window
    @x = window.width/2.0 - @carpet_image.width/2.0
    @x += 1 if window.width.odd? && @carpet_image.width.odd?
    @y = window.height/(18/13.0) - @carpet_image.height/2.0
  end

  def bottom
    y + height
  end

  def right
    x + width
  end

  def draw
    @carpet_image.draw(@x, @y, 4)
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
    images_overlap?(object) && !opaque_overlapping_pixels(object).empty?
  end

  def images_overlap?(object)
    object.bottom  > top    &&
      object.top   < bottom &&
      object.right > left   &&
      object.left  < right
  end

  def opaque_overlapping_pixels(object)
    overlapping_pixels(object).select do |x,y|
      !@carpet_image.transparent_pixel?(x,y) && !object.image.transparent_pixel?(x,y)
    end
  end

  def overlapping_pixels(object)
    if x < object.x
      box_width = x + width - object.x
      box_x = object.x
    else
      box_width = object.x + object.width - x
      box_x = x
    end
    if y < object.y
      box_height = y + height - object.y
      box_y = object.y
    else
      box_height = object.y + object.height - y
      box_y = y
    end
    pixels(box_x, box_y, box_width, box_height)
  end

  def pixels(offset_x, offset_y, width, height)
    height.round.times.flat_map do |y|
      width.round.times.map do |x|
        [(x + offset_x).to_i, (y + offset_y).to_i]
      end
    end
  end


end
