require_relative 'piece'

class Pawn < Piece
  attr_reader :char, :possible_moves

  def initialize(position=[1,0], color=0)
    super(position, color)
    @char = ['♟','♙'][color]
    @possible_moves = [[1,0],[2,0]]
  end

  def remove_double_move
    @possible_moves.delete([2,0])
  end
end