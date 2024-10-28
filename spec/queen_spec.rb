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
        #Horizontal & Vertical
        [1,0],
        [0,1],
        [-1,0],
        [0,-1],
        #Diagonal
        [1,1],
        [-1,1],
        [-1,-1],
        [1,-1]])
    end
  end
end