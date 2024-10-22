class Piece
  attr_reader :position, :color, :char

  def initialize(position=[0,0], color=0, char='')
    @pieces = {
      '' => ['♟','♙'],
      'R' => ['♜','♖'],
      'N' => ['♞','♘'],
      'B' => ['♝','♗'],
      'Q' => ['♛','♕'],
      'K' => ['♚','♔']
    }
    @position = position
    @color = color
    @char = @pieces[char][self.color]
  end
end