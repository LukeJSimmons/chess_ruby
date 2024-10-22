require_relative 'piece'

class Bishop < Piece
  attr_reader :char, :possible_moves

  def initialize(position=[0,0], color=0)
    super(position, color)
    @char = ['♝','♗'][color]
    @possible_moves = [
      [1,1],[2,2],[3,3],[4,4],[5,5],[6,6],[7,7],
      [-1,1],[-2,2],[-3,3],[-4,4],[-5,5],[-6,6],[-7,7],
      [-1,-1],[-2,-2],[-3,-3],[-4,-4],[-5,-5],[-6,-6],[-7,-7],
      [1,-1],[2,-2],[3,-3],[4,-4],[5,-5],[6,-6],[7,-7],]
  end
end