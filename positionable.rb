require 'forwardable'

module Positionable
  attr_accessor :x, :y
  alias :top :y
  alias :left :x
  extend Forwardable
  def_delegators :primary_image, :height, :width

  def bottom
    y + height
  end

  def right
    x + width
  end

  def primary_image
    raise NotImplementedError.new("Positionable objects must define a primary image")
  end


end