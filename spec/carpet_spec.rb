require 'rspec'
require 'gosu'
require_relative '../carpet'

describe Carpet do

  subject do
    window = Gosu::Window.new(9, 9, false)
    Carpet.new(window, 'spec/fixtures/capital_i.png', 'spec/fixtures/capital_i.png')
  end

  describe '#x' do
    it 'should be horizontally centered' do
      expect(subject.x).to eq(4)
    end
  end

end