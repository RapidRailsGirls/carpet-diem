class Endboss

  def initialize(window)
    @image = Gosu::Image.new(window, 'lib/media/endboss.png')
    @x = window.width/2 - @image.width/2
    @y = window.height
    @scale = 0.0
  end

  def draw
    @scale += 0.03 if @scale <= 1
    @image.draw(@x, @y - 750 * @scale, 3, @scale, @scale)
  end

end