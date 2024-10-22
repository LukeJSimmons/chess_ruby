require './lib/knight'

describe Knight do
  subject(:knight) { described_class.new }

  describe '#char' do
    context 'when color is white' do
      it 'returns white knight' do
        expect(knight.char).to eq('♞')
      end
    end

    context 'when color is black' do
      subject(:knight) { described_class.new([0,1],1) }
      it 'returns black knight' do
        expect(knight.char).to eq('♘')
      end
    end
  end

  describe '#possible_moves' do
    it 'returns all spots 2 and 1 over' do
      expect(knight.possible_moves).to eq([[1,2],[2,1],[2,-1],[1,-2],[-1,-2],[-2,-1],[-2,1],[-1,2]])
    end
  end
end