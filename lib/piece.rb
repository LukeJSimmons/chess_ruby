class Piece
  attr_reader :position, :color

  def initialize(position=[0,0], color=0)
    @position = position
    @color = color
  end

  def remove
    @position = nil
  end
end