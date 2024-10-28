require_relative 'piece'

class Rook < Piece
  attr_reader :char, :possible_moves

  def initialize(position=[0,0], color=0)
    super(position, color)
    @char = ['♜','♖'][color]
    @possible_moves = [
      [1,0],
      [0,1],
      [-1,0],
      [0,-1]
    ]
  end
end