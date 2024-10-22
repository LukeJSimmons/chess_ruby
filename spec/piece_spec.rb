require './lib/piece'

describe Piece do
  subject(:piece) { described_class.new }

  describe '#position' do
    context 'when no position is given' do
      it 'should return position' do
        expect(piece.position).to eq([0,0])
      end
    end

    context 'when position is given' do
      subject(:piece) { described_class.new([2,2]) }

      it 'should return position' do
        expect(piece.position).to eq([2,2])
      end
    end
  end

  describe '#color' do
    context 'when no color is given' do
      it 'should return white' do
        expect(piece.color).to eq(0)
      end
    end

    context 'when white is given' do
      subject(:piece) { described_class.new([0,0],0) }
      it 'should return white' do
        expect(piece.color).to eq(0)
      end
    end

    context 'when black is given' do
      subject(:piece) { described_class.new([0,0],1) }
      it 'should return black' do
        expect(piece.color).to eq(1)
      end
    end
  end

  describe '#remove' do
    it 'sets position to nil' do
      expect { piece.remove }.to change { piece.position }.to(nil)
    end
  end
end