require './lib/queen'

describe Queen do
  subject(:queen) { described_class.new }

  describe '#char' do
    context 'when color is white' do
      it 'returns white queen' do
        expect(queen.char).to eq('♛')
      end
    end

    context 'when color is black' do
      subject(:queen) { described_class.new([0,0],1) }

      it 'returns black queen' do
        expect(queen.char).to eq('♕')
      end
    end
  end

  describe '#possible_moves' do
    it 'returns all horizontal, vertical, diagonal and adjacent spots' do
      expect(queen.possible_moves).to eq([
        #Adjacent
        [1,0],[1,-1],[0,-1],[-1,-1],[-1,0],[-1,1],[0,1],[1,1],
        #Horizontal & Vertical
        [1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],
        [0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7],
        [-1,0],[-2,0],[-3,0],[-4,0],[-5,0],[-6,0],[-7,0],
        [0,-1],[0,-2],[0,-3],[0,-4],[0,-5],[0,-6],[0,-7],
        #Diagonal
        [1,1],[2,2],[3,3],[4,4],[5,5],[6,6],[7,7],
        [-1,1],[-2,2],[-3,3],[-4,4],[-5,5],[-6,6],[-7,7],
        [-1,-1],[-2,-2],[-3,-3],[-4,-4],[-5,-5],[-6,-6],[-7,-7],
        [1,-1],[2,-2],[3,-3],[4,-4],[5,-5],[6,-6],[7,-7]])
    end
  end
end