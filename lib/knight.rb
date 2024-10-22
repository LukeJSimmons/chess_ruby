require_relative 'piece'

class Knight < Piece
  attr_reader :char, :possible_moves
  def initialize(position=[0,1], color=0)
    super(position, color)
    @char = ['♞','♘'][color]
    @possible_moves = [[1,2],[2,1],[2,-1],[1,-2],[-1,-2],[-2,-1],[-2,1],[-1,2]]
  end
end