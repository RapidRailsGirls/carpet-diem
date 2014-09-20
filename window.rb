class Window < Gosu::Window
  NUM_TILES = 6
  TILE_COLS = 2
  VELOCITY = 3
  BLACK = Gosu::Color.argb(0xff000000)

  module YAccessible
    attr_writer :y
    def y
      @y.to_i
    end
  end

  def initialize
    super(1200, 800, false)
    @carpet = Carpet.new(self)
    @backgrounds = NUM_TILES.times.collect do
      Gosu::Image.new(self, 'media/background.jpg', true).extend(YAccessible)
    end
    @font = Gosu::Font.new(self, Gosu::default_font_name, 60)
    @yplus = -@backgrounds.last.height
    @counter = 0
    @genielamps = []
    @endboss = []
    @score = 1
  end

  def draw
    @carpet.draw
    @font.draw("Score: #{@score}", 10, 10, 5, 1, 1, color = BLACK)
    @backgrounds.each_with_index do | bg, index |
      bg.y = (index / TILE_COLS) * bg.height + @yplus
      bg.draw((index % TILE_COLS) * bg.width, bg.y, 1)
    end
    @genielamps.each {|genielamp| genielamp.draw}
    @endboss.each {|endboss| endboss.draw}
  end

  def update
    @counter += 1
    if button_down? Gosu::KbLeft
      @carpet.move_left
    end
    if button_down? Gosu::KbRight
      @carpet.move_right
    end
    scroll_background
    unless @score == 0
      if @counter % 120 == 1
        @genielamps.push LampWithGenie.new(self)
      end
    else
      @endboss.push Endboss.new(self) if @endboss.empty? && @genielamps.empty?
    end
    scroll_lamps
    @genielamps.any? do |genielamp|
      if !genielamp.lamp.rubbed? && @carpet.collides_with?(genielamp.lamp)
        genielamp.lamp.rub!
      end
      if genielamp.lamp.rubbed? && !genielamp.genie.captured? && @carpet.collides_with?(genielamp.genie)
        genielamp.genie.capture!
        if genielamp.genie.good?
          @score += 1
        else
          @score -= 1
        end
      end
      @genielamps.each do |genielamp|
        if genielamp.off_screen?(self)
          @genielamps.delete(genielamp)
        end
      end
    end

  end

  def scroll_background
    bg = @backgrounds.last
    if bg.y >= ((NUM_TILES / TILE_COLS) - 1) * bg.height - VELOCITY
      @yplus = -bg.height
    else
      @yplus += VELOCITY - 1
    end
  end

  def scroll_lamps
    @genielamps.each do |genielamp|
      genielamp.scroll(VELOCITY)
    end
  end
end
