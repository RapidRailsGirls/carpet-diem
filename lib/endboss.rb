class Endboss
attr_reader :endboss

  def initialize(window)
    @image = Gosu::Image.new(window, 'lib/media/endboss.png')
    @x = window.width/2 - @image.width/2
    @y = window.height
    @scale = 0.0
    @sound = Gosu::Sample.new(window, 'lib/media/evil_laughter.m4a')
    @laughs = false
  end

  def draw
    @scale += 0.03 if @scale <= 1
    @image.draw(@x, @y - 750 * @scale, 3, @scale, @scale)
  end

  def laugh!
    return @laughs if @laughs
    @laughs = true
    @sound.play
  end
end