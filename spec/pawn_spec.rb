require './lib/pawn'

describe Pawn do
  subject(:pawn) { described_class.new }

  describe '#char' do
    context 'when color is white' do
      it 'returns white pawn' do
        expect(pawn.char).to eq('♟')
      end
    end

    context 'when color is black' do
      subject(:pawn) { described_class.new([0,0],1) }

      it 'returns black pawn' do
        expect(pawn.char).to eq('♙')
      end
    end
  end

  describe '#possible_moves' do
    context 'when first turn' do
      it 'returns one step and two step forward' do
        expect(pawn.possible_moves).to eq([[1,0],[2,0]])
      end
    end
  end
end