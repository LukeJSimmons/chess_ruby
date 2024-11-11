class Piece
  attr_accessor :position
  attr_reader :color

  def initialize(position=[0,0], color=0)
    @position = position
    @color = color
  end
end