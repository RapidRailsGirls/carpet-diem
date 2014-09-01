require 'forwardable'

class LampWithGenie
  extend Forwardable
  def_delegators :@lamp, :height, :width
  attr_accessor :rubbed, :x, :y
  alias :rubbed? :rubbed
  undef :rubbed

  def initialize(window)
    @scale = 0.0
    if flipped?
      @lamp = Gosu::Image.new(window, 'media/lamp_flipped.png')
      if good?
        @genie = Gosu::Image.new(window, 'media/good_genie_flipped.png')
      else
        @genie = Gosu::Image.new(window, 'media/evil_genie_flipped.png')
      end
    else
      @lamp = Gosu::Image.new(window, 'media/lamp.png')
      if good?
        @genie = Gosu::Image.new(window, 'media/good_genie.png')
      else
        @genie = Gosu::Image.new(window, 'media/evil_genie.png')
      end
    end
    @rubbed = false
    @x = rand(@genie.width/2..(WINDOW_WIDTH - @genie.width))
    @y = -@lamp.height
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
    @lamp.draw(@x, @y, 2)
    if rubbed?
      @scale += 0.03 if @scale <= 1
      if !flipped? && good?
        @genie.draw(@x - 150 * @scale, @y - 200 * @scale, 3, @scale, @scale)
      elsif !flipped? && evil?
        @genie.draw(@x - 150 * @scale, @y - 200 * @scale, 3, @scale, @scale)
      elsif flipped? && good?
        @genie.draw(@x + 150, @y - 200 * @scale, 3, @scale, @scale)
      elsif flipped? && evil?
        @genie.draw(@x + 120, @y - 200 * @scale, 3, @scale, @scale)
      end
    end
  end
end