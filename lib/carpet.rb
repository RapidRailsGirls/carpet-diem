require 'texplay'
require 'chingu'
require_relative 'positionable'

class Carpet
  include Positionable
  CARPET_SPEED = 5
  attr_reader :carpet_image
  alias :image :carpet_image
  undef :carpet_image

  def initialize(window, carpet_image_file = 'carpet.png', carpet_image_flipped_file = 'carpet_flipped.png')
    @carpet_image = @carpet_image_right = Gosu::Image.new(window, path_to_media(carpet_image_file))
    @carpet_image_left = Gosu::Image.new(window, path_to_media(carpet_image_flipped_file))
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
    if left < object.left
      box_left = object.left
      if right < object.right * object.scale
        box_width = right - object.left
      else
        box_width = object.width * object.scale
      end
    else
      box_width = object.right * object.scale - left
      box_left = left
    end
    if top < object.top
      box_top = object.top
      if bottom < object.bottom * object.scale
        box_height = bottom - object.top
      else
        box_height = object.height * object.scale
      end
    else
      box_top = top
      box_height = object.bottom * object.scale - top
    end
    pixels(box_left, box_top, box_width, box_height)
  end

  def pixels(offset_x, offset_y, width, height)
    height.round.times.flat_map do |y|
      width.round.times.map do |x|
        [(x + offset_x).to_i, (y + offset_y).to_i]
      end
    end
  end

end
