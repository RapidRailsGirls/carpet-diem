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

end