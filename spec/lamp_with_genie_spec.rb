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

end