require './lib/rook'

describe Rook do
  subject(:rook) { described_class.new }

  describe '#char' do
    context 'when color is white' do
      it 'returns white rook' do
        expect(rook.char).to eq('♜')
      end
    end

    context 'when color is black' do
      subject(:rook) { described_class.new([0,0],1) }
      it 'returns black rook' do
        expect(rook.char).to eq('♖')
      end
    end
  end

  describe '#possible_moves' do
    it 'returns all spots up, down, left or right' do
      expect(rook.possible_moves).to eq([
        [1,0],
        [0,1],
        [-1,0],
        [0,-1]
      ])
    end
  end
end