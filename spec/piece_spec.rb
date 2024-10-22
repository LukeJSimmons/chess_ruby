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

  describe '#char' do
    context 'when no char is given' do
      it 'should return white pawn' do
        expect(piece.char).to eq('♟')
      end
    end

    describe 'pawn' do
      context 'when white pawn is given' do
        it 'should return white pawn' do
          expect(piece.char).to eq('♟')
        end
      end

      context 'when black pawn is given' do
        subject(:piece) { described_class.new([0,0],1) }
        it 'should return black pawn' do
          expect(piece.char).to eq('♙')
        end
      end
    end

    describe 'rook' do
      context 'when white rook is given' do
        subject(:piece) { described_class.new([0,0],0,'R') }
        it 'should return white rook' do
          expect(piece.char).to eq('♜')
        end
      end

      context 'when black rook is given' do
        subject(:piece) { described_class.new([0,0],1,'R') }
        it 'should return black rook' do
          expect(piece.char).to eq('♖')
        end
      end
    end

    describe 'knight' do
      context 'when white knight is given' do
        subject(:piece) { described_class.new([0,0],0,'N') }
        it 'should return white knight' do
          expect(piece.char).to eq('♞')
        end
      end

      context 'when black knight is given' do
        subject(:piece) { described_class.new([0,0],1,'N') }
        it 'should return black knight' do
          expect(piece.char).to eq('♘')
        end
      end
    end

    describe 'bishop' do
      context 'when white bishop is given' do
        subject(:piece) { described_class.new([0,0],0,'B') }
        it 'should return white bishop' do
          expect(piece.char).to eq('♝')
        end
      end

      context 'when black bishop is given' do
        subject(:piece) { described_class.new([0,0],1,'B') }
        it 'should return black bishop' do
          expect(piece.char).to eq('♗')
        end
      end
    end

    describe 'queen' do
      context 'when white queen is given' do
        subject(:piece) { described_class.new([0,0],0,'Q') }
        it 'should return white queen' do
          expect(piece.char).to eq('♛')
        end
      end

      context 'when black queen is given' do
        subject(:piece) { described_class.new([0,0],1,'Q') }
        it 'should return black queen' do
          expect(piece.char).to eq('♕')
        end
      end
    end

    describe 'king' do
      context 'when white king is given' do
        subject(:piece) { described_class.new([0,0],0,'K') }
        it 'should return white king' do
          expect(piece.char).to eq('♚')
        end
      end

      context 'when black king is given' do
        subject(:piece) { described_class.new([0,0],1,'K') }
        it 'should return black king' do
          expect(piece.char).to eq('♔')
        end
      end
    end
  end
end