require_relative 'positionable'

class LampWithGenie
  attr_reader :lamp, :genie

  class Lamp
    include Positionable
    attr_reader :image

    def initialize(window, x, flipped)
      if flipped
        @image = Gosu::Image.new(window, 'media/lamp_flipped.png')
      else
        @image = Gosu::Image.new(window, 'media/lamp.png')
      end

      @sound = Gosu::Sample.new(window, 'media/lamp.m4a')
      @rubbed = false
      @y = -@image.height
      @x = x
#      @flipped = flipped
    end

    def draw
      @image.draw(@x, @y, 2)
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

    def initialize(window, x, flipped)
      prefix = if good?
        'good'
      else
        'evil'
      end
      suffix  = '_flipped' if flipped
      @image = Gosu::Image.new(window, "media/#{prefix}_genie#{suffix}.png")
      @sound = Gosu::Sample.new(window, "media/#{prefix}_genie.m4a")
      @y = -@image.height
      @x = if flipped
        x + 120
      else
        x - 150
      end
      @flipped = flipped
      @captured = false
      @scale = 0.0

    end

    def draw_near(lamp)
      @scale += 0.03 if @scale <= 1
      if @flipped
        @image.draw(lamp.x + 120, lamp.y - 180 * @scale, 3, @scale, @scale)
      else
        @image.draw(lamp.x - 150 * @scale, lamp.y - 180 * @scale, 3, @scale, @scale)
      end
    end

    def capture!
      return @captured if @captured
      @captured = true
      @sound.play
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

 # END OF GENIE
#####################################################################

  def initialize(window)
    x = rand(0..window.width)
    flipped = rand(2) == 0
    @genie = Genie.new(window, x, flipped)
    @lamp = Lamp.new(window, x, flipped)
  end

  def scroll(speed)
    @lamp.y += speed
    @genie.y += speed
  end

  def draw
    @lamp.draw
    if @lamp.rubbed?
      @genie.draw_near(@lamp)
    end
  end
end