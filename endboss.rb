class Endboss

  def initialize(window)
    @image = Gosu::Image.new(window, 'media/evil_genie_flipped.png')
    @x = 200
    @y = 700
    @scale = 0.0
  end

  def draw
    @scale += 0.03 if @scale <= 1
    @image.draw(@x, @y - 600 * @scale, 3, 3.5 * @scale, 3.5 * @scale)
  end

end