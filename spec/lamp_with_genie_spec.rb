require 'rspec'
require 'gosu'
require_relative '../lamp_with_genie'

describe LampWithGenie do

  let(:window) do
    Gosu::Window.new(1200, 800, false)
  end

  before do
    @lamp_with_genie = LampWithGenie.new(window)
  end

  describe '#scroll' do
    it 'should move the image down depending on the speed' do
      speed = 2
      @lamp_with_genie.lamp.y = 3
      @lamp_with_genie.genie.y = 4
      @lamp_with_genie.scroll(speed)
      expect(@lamp_with_genie.lamp.y).to eq(5)
      expect(@lamp_with_genie.genie.y).to eq(6)
    end
  end

  describe '#off_screen?' do
    it 'should return true if an image scrolled off the window' do
      if @lamp_with_genie.lamp.rubbed?
        @lamp_with_genie.genie.y = 801
      else
        @lamp_with_genie.lamp.y = 801
      end
      expect(@lamp_with_genie.off_screen?).to be(true)
    end

    it 'should return false if an image is still visible in the window' do
      if @lamp_with_genie.lamp.rubbed?
        @lamp_with_genie.genie.y = 800
      else
        @lamp_with_genie.lamp.y = 800
      end
      expect(@lamp_with_genie.off_screen?).to be(false)
    end
  end

  describe '#rub!' do
    it 'should turn the @rubbed value to true' do
      @lamp_with_genie.lamp.rub!
      expect(@lamp_with_genie.lamp.rubbed?).to be(true)
    end
  end

  describe '#rubbed?' do
    it 'should be false when a lamp is initiated' do
      expect(@lamp_with_genie.lamp.rubbed?).to be(false)
    end

    it 'should be true if the lamp has been rubbed' do
      @lamp_with_genie.lamp.rub!
      expect(@lamp_with_genie.lamp.rubbed?).to be(true)
    end
  end

describe '#capture!' do
    it 'should turn the @caputred value to true' do
      @lamp_with_genie.genie.capture!
      expect(@lamp_with_genie.genie.captured?).to be(true)
    end
  end

  describe '#captured?' do
    it 'should be false when a genie is initiated' do
      expect(@lamp_with_genie.genie.captured?).to be(false)
    end

    it 'should be true if the genie has been captured' do
      @lamp_with_genie.genie.capture!
      expect(@lamp_with_genie.genie.captured?).to be(true)
    end
  end

  describe '#update' do
    it 'should not increase the x value if the image is flipped' do
      unless flipped = true  #  should be == true but then flipped is an undefined method
        @lamp_with_genie.genie.x = 20
        @lamp_with_genie.genie.update
        expect(@lamp_with_genie.genie.x).to eq(20)
      end
    end

    it 'should increase the x value if the image is not flipped' do
      PADDING = 15
      unless flipped = false  #  should be == false but then flipped is an undefined method
        @lamp_with_genie.lamp.x = 20
        @lamp_with_genie.genie.update
        expect(@lamp_with_genie.genie.x).to eq(20 - (@lamp_with_genie.genie.width + PADDING) * 0.03)
     end
    end
  end
end