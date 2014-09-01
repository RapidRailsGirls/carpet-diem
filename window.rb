class Window < Gosu::Window
  NUM_TILES = 6
  TILE_COLS = 2
  VELOCITY = 3

  module YAccessible
    attr_writer :y
    def y
      @y.to_i
    end
  end

  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT, false)
    @carpet = Carpet.new(self)
    @backgrounds = NUM_TILES.times.collect do
      Gosu::Image.new(self, 'media/background.jpg', true).extend(YAccessible)
    end
    @yplus = -@backgrounds.last.height
    @counter = 0
    @lamps = []
  end

  def draw
    @carpet.draw
    @backgrounds.each_with_index do | bg, index |
      bg.y = (index / TILE_COLS) * bg.height + @yplus
      bg.draw((index % TILE_COLS) * bg.width, bg.y, 1)
    end
    @lamps.each {|lamp| lamp.draw}
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
    if @counter % 60 == 0
      @lamps.push LampWithGenie.new(self)
    end
    scroll_lamps
    @lamps.any? do |lamp|
      if @carpet.collides_with?(lamp)
        lamp.rubbed = true
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
    @lamps.each do |lamp|
      lamp.y += VELOCITY
    end
  end
end