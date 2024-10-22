require_relative 'piece'

class Rook < Piece
  attr_reader :char, :possible_moves

  def initialize(position=[0,0], color=0)
    super(position, color)
    @char = ['♜','♖'][color]
    @possible_moves = [
      [1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],
      [0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7],
      [-1,0],[-2,0],[-3,0],[-4,0],[-5,0],[-6,0],[-7,0],
      [0,-1],[0,-2],[0,-3],[0,-4],[0,-5],[0,-6],[0,-7]]
  end
end