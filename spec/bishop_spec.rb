require './lib/bishop'

describe Bishop do
  subject(:bishop) { described_class.new }

  describe '#char' do
    context 'when color is white' do
      it 'returns white bishop' do
        expect(bishop.char).to eq('♝')
      end
    end

    context 'when color is black' do
      subject(:bishop) { described_class.new([0,0],1) }

      it 'returns black bishop' do
        expect(bishop.char).to eq('♗')
      end
    end
  end

  describe '#possible_moves' do
    it 'returns all diagonal spots' do
      expect(bishop.possible_moves).to eq([
        [1,1],[2,2],[3,3],[4,4],[5,5],[6,6],[7,7],
        [-1,1],[-2,2],[-3,3],[-4,4],[-5,5],[-6,6],[-7,7],
        [-1,-1],[-2,-2],[-3,-3],[-4,-4],[-5,-5],[-6,-6],[-7,-7],
        [1,-1],[2,-2],[3,-3],[4,-4],[5,-5],[6,-6],[7,-7],])
    end
  end
end