require 'rspec'
require 'gosu'
require_relative '../carpet'

describe Carpet do

  let(:window) do
    Gosu::Window.new(9, 9, false)
  end

  describe '#x' do
    it 'should start horizontally centered' do
      carpet = Carpet.new(window, 'spec/fixtures/capital_i.png', 'spec/fixtures/capital_i.png')
      expect(carpet.x).to eq(4)
    end
  end

  describe '#y' do
    it 'should start in the lower three-fifths of the window' do
      carpet = Carpet.new(window, 'spec/fixtures/capital_i.png', 'spec/fixtures/capital_i.png')
      expect(carpet.y).to eq(5)
    end
  end

  describe '#collides_with?' do

    xit 'should not collide if carpet intersects with other object' do
     carpet = Carpet.new(window, 'spec/fixtures/capital_i.png', 'spec/fixtures/capital_i.png')
     carpet2 = Carpet.new(window, 'spec/fixtures/plus.png', 'spec/fixtures/plus.png')
     carpet.x = 0
     carpet.y = 0
     carpet2.x = 2
     carpet2.y = 0
     expect(carpet.collides_with?(carpet2)).to be(false)
   end

    it 'should not collide if carpet does not intersects with other object' do
     carpet = Carpet.new(window, 'spec/fixtures/capital_i.png', 'spec/fixtures/capital_i.png')
     carpet2 = Carpet.new(window, 'spec/fixtures/plus.png', 'spec/fixtures/plus.png')
     carpet.x = 0
     carpet.y = 0
     carpet2.x = 4
     carpet2.y = 0
     expect(carpet.collides_with?(carpet2)).to be(false)
   end

    it 'should collide if carpet overlaps with other object' do
     carpet = Carpet.new(window, 'spec/fixtures/capital_i.png', 'spec/fixtures/capital_i.png')
     carpet2 = Carpet.new(window, 'spec/fixtures/plus.png', 'spec/fixtures/plus.png')
     carpet.x = 0
     carpet.y = 0
     carpet2.x = 0
     carpet2.y = 0
     expect(carpet.collides_with?(carpet2)).to be(true)
   end
  end

end