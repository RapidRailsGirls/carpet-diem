require_relative 'positionable'

class LampWithGenie
  attr_reader :lamp, :genie

  class Lamp
    include Positionable
    attr_reader :image

    def initialize(window, x)
      @image = Gosu::Image.new(window, 'media/lamp.png')
      @sound = Gosu::Sample.new(window, 'media/lamp.m4a')
      @rubbed = false
      @y = -@image.height
      @x = x
    end

    def rub!
      return @rubbed if @rubbed
      @rubbed = true
      @sound.play
    end

    def rubbed?
      @rubbed
    end
  end


  class Genie
    include Positionable
    attr_reader :image

    def initialize(window, x)
      if good?
        @image = Gosu::Image.new(window, 'media/good_genie.png')
      else
        @image = Gosu::Image.new(window, 'media/evil_genie.png')
      end
      @good_sound = Gosu::Sample.new(window, 'media/good_genie.m4a')
      @evil_sound = Gosu::Sample.new(window, 'media/evil_genie.m4a')

      @y = -@image.height
      @x = x # that's wrong
      @captured = false
    end

    def capture!
      return @captured if @captured
      @captured = true
      if good?
        @good_sound.play
      else
        @evil_sound.play
      end
    end

    def captured?
      @captured
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
  end

  def initialize(window)
    x = rand(0..window.width)
    @genie = Genie.new(window, x)
    @lamp = Lamp.new(window, x)
    @scale = 0.0
  end

  def flipped?
    if defined? @flipped
      return @flipped
    else
      @flipped = rand(2) == 0
    end
  end

  def scroll(speed)
    @lamp.y += speed
    @genie.y += speed
  end

  def draw
    @lamp.image.draw(@lamp.x, @lamp.y, 2)
    if @lamp.rubbed?
      @scale += 0.03 if @scale <= 1
      if !flipped? && @genie.good?
        @genie.image.draw(@lamp.x - 150 * @scale, @lamp.y - 200 * @scale, 3, @scale, @scale)
      elsif !flipped? && @genie.evil?
        @genie.image.draw(@lamp.x - 150 * @scale, @lamp.y - 200 * @scale, 3, @scale, @scale)
      elsif flipped? && @genie.good?
        @genie.image.draw(@lamp.x + 150, @lamp.y - 200 * @scale, 3, @scale, @scale)
      elsif flipped? && @genie.evil?
        @genie.image.draw(@lamp.x + 120, @lamp.y - 200 * @scale, 3, @scale, @scale)
      end
    end
  end
end