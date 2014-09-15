require 'forwardable'

class LampWithGenie
  extend Forwardable
  def_delegators :@lamp_image, :height, :width
  attr_accessor :x, :y
  attr_reader :lamp_image
  alias :image :lamp_image
  undef :lamp_image
  alias :left :x
  alias :top :y

  def initialize(window)
    @scale = 0.0
    if flipped?
      @lamp_image = Gosu::Image.new(window, 'media/lamp_flipped.png')
      if good?
        @genie_image = Gosu::Image.new(window, 'media/good_genie_flipped.png')
      else
        @genie_image = Gosu::Image.new(window, 'media/evil_genie_flipped.png')
      end
    else
      @lamp_image = Gosu::Image.new(window, 'media/lamp.png')
      if good?
        @genie_image = Gosu::Image.new(window, 'media/good_genie.png')
      else
        @genie_image = Gosu::Image.new(window, 'media/evil_genie.png')
      end
    end
    @x = rand(@genie_image.width/2..(window.width - @genie_image.width))
    @y = -@lamp_image.height
    @rubbed = false
    @lamp_sound = Gosu::Sample.new(window, 'media/lamp.m4a')
  end

  def bottom
    y + height
  end

  def right
    x + width
  end

  def rub!
    return @rubbed if @rubbed
    @rubbed = true
    @lamp_sound.play
  end

  def rubbed?
    @rubbed
  end

  def good?
    if defined? @good
      return @good
    else
      @good = rand(2) == 0
    end
  end

  def evil?
    !good?
  end

  def flipped?
    if defined? @flipped
      return @flipped
    else
      @flipped = rand(2) == 0
    end
  end

  def scroll(speed)
    @y += speed
  end

  def draw
    @lamp_image.draw(@x, @y, 2)
    if rubbed?
      @scale += 0.03 if @scale <= 1
      if !flipped? && good?
        @genie_image.draw(@x - 150 * @scale, @y - 200 * @scale, 3, @scale, @scale)
      elsif !flipped? && evil?
        @genie_image.draw(@x - 150 * @scale, @y - 200 * @scale, 3, @scale, @scale)
      elsif flipped? && good?
        @genie_image.draw(@x + 150, @y - 200 * @scale, 3, @scale, @scale)
      elsif flipped? && evil?
        @genie_image.draw(@x + 120, @y - 200 * @scale, 3, @scale, @scale)
      end
    end
  end
end