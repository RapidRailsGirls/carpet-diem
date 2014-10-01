require_relative 'positionable'

class LampWithGenie
  attr_reader :lamp, :genie

  class Lamp
    include Positionable
    attr_reader :image, :scale

    def initialize(window, flipped)
      if flipped
        @image = Gosu::Image.new(window, path_to_media('lamp_flipped.png'))
      else
        @image = Gosu::Image.new(window, path_to_media('lamp.png'))
      end
      @sound = Gosu::Sample.new(window, path_to_media('lamp.wav'))
      @rubbed = false
      @y = -@image.height
      @scale = 1
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
    attr_reader :image, :scale
    PADDING = 15
    def initialize(window, flipped, lamp)
      prefix = good? ? 'good' : 'evil'
      suffix = '_flipped' if flipped
      @image = Gosu::Image.new(window, path_to_media("#{prefix}_genie#{suffix}.png"))
      @sound = Gosu::Sample.new(window, path_to_media("#{prefix}_genie.wav"))
      @lamp = lamp
      @y = -@image.height
      @flipped = flipped
      @captured = false
      @scale = 0.0
    end

    def draw
      @image.draw(@x, @y, 3, @scale, @scale)
    end

    def update
      @scale += 0.03 if @scale <= 1
      if @flipped
        @x = @lamp.x + width - PADDING
        @y = @lamp.y - height * @scale
      else
        @x = (@lamp.x - (width + PADDING) * @scale)
        @y = (@lamp.y - height * @scale)
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

  def initialize(window)
    flipped = rand(2) == 0
    @lamp = Lamp.new(window, flipped)
    @genie = Genie.new(window, flipped, @lamp)
    x = if flipped
      rand(0..(window.width - @genie.width - @lamp.width))
    else
      rand(@genie.width..(window.width - @lamp.width))
    end
    @lamp.x = x
    @genie.x = flipped ? x + @lamp.width : x
    @window = window
  end

  def scroll(speed)
    @lamp.y += speed
    @genie.y += speed
  end

  def draw
    @lamp.draw
    @genie.update && @genie.draw if @lamp.rubbed?
  end

  def off_screen?
    if @lamp.rubbed?
      @genie.y > @window.height
    else
      @lamp.y > @window.height
    end
  end
end