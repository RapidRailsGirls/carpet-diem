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

    it 'should not collide if carpet intersects with other object' do
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

  describe '#pixels' do
    it 'should return an array of arrays whose number of elements should equal width * height' do
      carpet = Carpet.new(window)
      x = 0
      y = 0
      height = 2
      width = 2
      pixel_array = carpet.pixels(x, y, width, height)
      expect(pixel_array).to be_an Array
      expect(pixel_array.size).to eq(width * height)
      pixel_array.each do |pixel|
        expect(pixel).to be_an Array
        expect(pixel.size).to eq(2)
        pixel.each do |coordinate| 
          expect(coordinate).to be_an Integer
        end
      end
    end

    it 'should return the correct coordinates' do
      carpet = Carpet.new(window)
      pixel_array = carpet.pixels(0,0,2,2)
      expect(pixel_array).to match_array([[0,0],[1,0],[0,1],[1,1]])

      pixel_array = carpet.pixels(1,1,2,2)
      expect(pixel_array).to match_array([[1,1],[2,1],[1,2],[2,2]])

      pixel_array = carpet.pixels(2,2,2,2)
      expect(pixel_array).to match_array([[2,2],[3,2],[2,3],[3,3]])

      pixel_array = carpet.pixels(0,2,2,2)
      expect(pixel_array).to match_array([[0,2],[1,2],[0,3],[1,3]])

      pixel_array = carpet.pixels(1,1,1,3)
      expect(pixel_array).to match_array([[1,1],[1,2],[1,3]])
    end
  end

  describe '#overlapping_pixels' do 
    it 'should return an array of arrays with 2 integers in it' do 
      carpet = Carpet.new(window, 'spec/fixtures/capital_i.png', 'spec/fixtures/capital_i.png')
      carpet2 = Carpet.new(window, 'spec/fixtures/plus.png', 'spec/fixtures/plus.png')
      carpet.x = 0
      carpet.y = 0
      carpet2.x = 2
      carpet2.y = 0
      pixel_array = carpet.overlapping_pixels(carpet2)
      expect(pixel_array).to be_an Array
      pixel_array.each do |pixel|
        expect(pixel).to be_an Array
        expect(pixel.size).to eq(2)
        pixel.each do |coordinate|
          expect(coordinate).to be_an Integer
        end
      end
    end

    it 'should return the overlapping pixels' do
      carpet = Carpet.new(window, 'spec/fixtures/capital_i.png', 'spec/fixtures/capital_i.png')
      carpet2 = Carpet.new(window, 'spec/fixtures/plus.png', 'spec/fixtures/plus.png')
      carpet.x = 0
      carpet.y = 0
      carpet2.x = 2
      carpet2.y = 0
      pixel_array = carpet.overlapping_pixels(carpet2)
      expect(pixel_array).to match_array([[2,0], [2,1], [2,2]])
    end
  end

  describe '#opaque_overlapping_pixels' do
    it 'should return an array of arrays with 2 integers in it' do
      carpet = Carpet.new(window, 'spec/fixtures/capital_i.png', 'spec/fixtures/capital_i.png')
      carpet2 = Carpet.new(window, 'spec/fixtures/plus.png', 'spec/fixtures/plus.png')
      carpet.x = 0
      carpet.y = 0
      carpet2.x = 0
      carpet2.y = 0
      pixel_array = carpet.opaque_overlapping_pixels(carpet2)
      expect(pixel_array).to be_an Array
      pixel_array.each do |pixel|
        expect(pixel).to be_an Array
        expect(pixel.size).to eq(2)
        pixel.each do |coordinate|
          expect(coordinate).to be_an Integer
        end
      end
    end

    it 'should return the opaque overlapping pixels' do
      carpet = Carpet.new(window, 'spec/fixtures/capital_i.png', 'spec/fixtures/capital_i.png')
      carpet2 = Carpet.new(window, 'spec/fixtures/plus.png', 'spec/fixtures/plus.png')
      carpet.x = 0
      carpet.y = 0
      carpet2.x = 0
      carpet2.y = 0
      pixel_array = carpet.opaque_overlapping_pixels(carpet2)
      expect(pixel_array).to match_array([[1,0], [1,1], [1,2]])
    end

  end

end