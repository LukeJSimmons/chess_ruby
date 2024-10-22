require_relative 'piece'

class Pawn < Piece
  attr_reader :char, :possible_moves

  def initialize(position=[1,0], color=0)
    super(position, color)
    @char = ['♟','♙'][color]
    @possible_moves = [[1,0],[2,0]]
  end

  def move(new_position)
    @position = new_position
    @possible_moves = [[1,0]]
  end
end