require './lib/king'

describe King do
  subject(:king) { described_class.new }

  describe '#char' do
    context 'when color is white' do
      it 'returns white king' do
        expect(king.char).to eq('♚')
      end
    end

    context 'when color is black' do
      subject(:king) { described_class.new([0,0],1) }
      it 'returns black king' do
        expect(king.char).to eq('♔')
      end
    end
  end

  describe '#possible_moves' do
    it 'returns adjacent spots' do
      expect(king.possible_moves).to eq([[1,0],[1,-1],[0,-1],[-1,-1],[-1,0],[-1,1],[0,1],[1,1]])
    end
  end
end