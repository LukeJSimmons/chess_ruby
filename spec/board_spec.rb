require './lib/board'
require './lib/piece'
require './lib/rook'
require './lib/knight'
require './lib/bishop'
require './lib/queen'
require './lib/pawn'
require './lib/king'

describe Board do
  subject(:board) { described_class.new }

  describe '#board' do
    context 'when board is requested' do
      it 'should return empty board' do
        expect(board.board).to eq([
        ['#','#','#','#','#','#','#','#'],
        ['#','#','#','#','#','#','#','#'],
        ['#','#','#','#','#','#','#','#'],
        ['#','#','#','#','#','#','#','#'],
        ['#','#','#','#','#','#','#','#'],
        ['#','#','#','#','#','#','#','#'],
        ['#','#','#','#','#','#','#','#'],
        ['#','#','#','#','#','#','#','#'],]);
      end
    end
  end

  describe '#setup_pieces' do
    context 'when game starts' do
      it 'should return all 32 pieces' do
        expect(board.pieces.length).to eq(32)
      end

      it 'should return correct Piece positions' do
        positions = board.pieces.map { |piece| piece.position }
        expect(positions).to eq([
        [0,0],[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7],
        [1,0],[1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[1,7],
        [7,0],[7,1],[7,2],[7,3],[7,4],[7,5],[7,6],[7,7],
        [6,0],[6,1],[6,2],[6,3],[6,4],[6,5],[6,6],[6,7],])
      end

      it 'should return correct Piece characters' do
        positions = board.pieces.map { |piece| piece.char }
        expect(positions).to eq([
          '♜','♞','♝','♛','♚','♝','♞','♜',
          '♟','♟','♟','♟','♟','♟','♟','♟',
          '♖','♘','♗','♕','♔','♗','♘','♖',
          '♙','♙','♙','♙','♙','♙','♙','♙'])
      end
    end
  end

  describe '#print' do
    before do
      allow(board).to receive(:take_input)
    end

    context 'when game starts' do
      it 'displays starting board correctly' do
        expect(board).to receive(:puts).with("\n8 ♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖ \n7 ♙ ♙ ♙ ♙ ♙ ♙ ♙ ♙ \n6 # # # # # # # # \n5 # # # # # # # # \n4 # # # # # # # # \n3 # # # # # # # # \n2 ♟ ♟ ♟ ♟ ♟ ♟ ♟ ♟ \n1 ♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜ \n  a b c d e f g h ")
        board.print
      end
    end
  end

  describe '#take_input' do
    before do
      allow(board).to receive(:move)
      allow(board).to receive(:exit)
    end

    context 'when a4 is input' do
      before do
        allow(board).to receive(:gets).and_return('a4')
      end

      it 'should request input' do
        expect(board).to receive(:gets)
        board.take_input
      end

      it 'should call move with a4' do
        expect(board).to receive(:move).with('',0,3)
        board.take_input
      end
    end

    context 'when Rh4 is input' do
      before do
        allow(board).to receive(:gets).and_return('Rh4')
      end

      it 'should call move with Rh4' do
        expect(board).to receive(:move).with('R',7,3)
        board.take_input
      end
    end

    context 'when q is input' do
      before do
        allow(board).to receive(:gets).and_return('q')
      end

      it 'should exit game' do
        expect(board).to receive(:exit)
        board.take_input
      end
    end
  end

  describe '#get_valid_moves' do
    describe 'rook' do
      context 'when called on Rh1' do
        it 'should return empty array' do
          expect(board.get_valid_moves(Rook.new([0,7]))).to eq([])
        end
      end

      context 'when called on Ra5' do
        it 'should return two up, seven right, and two down' do
          expect(board.get_valid_moves(Rook.new([4,0]))).to eq([[5,0],[6,0],[4,1],[4,2],[4,3],[4,4],[4,5],[4,6],[4,7],[3,0],[2,0]])
        end
      end

      context 'when king is in check' do
        subject(:board) { described_class.new([Rook.new([4,0],0),King.new([0,0],0),Rook.new([0,4],1)]) }

        it 'should return empty array' do
          expect(board.get_valid_moves(board.pieces[0])).to eq([])
        end
      end
    end

    describe 'bishop' do
      context 'when called on Bf1' do
        it 'should return empty array' do
          expect(board.get_valid_moves(Bishop.new([0,5]))).to eq([])
        end
      end
    end

    describe 'queen' do
      context 'when called on Qd1' do
        it 'should return empty array' do
          expect(board.get_valid_moves(Queen.new([0,3]))).to eq([])
        end
      end
    end

    describe 'knight' do
      context 'when called on Ng1' do
        it 'should return h3, f3, and e2' do
          expect(board.get_valid_moves(Knight.new([0,6]))).to eq([
            [2,7],[2,5]
          ])
        end
      end

      context 'when king is in check' do
        subject(:board) { described_class.new([Knight.new([4,0],0),King.new([0,0],0),Knight.new([1,2],1)]) }

        it 'should return empty array' do
          expect(board.get_valid_moves(board.pieces[0])).to eq([])
        end
      end
    end

    describe 'pawn' do
      context 'when called on a2' do
        it 'should return one step and two steps ahead' do
          expect(board.get_valid_moves(Pawn.new([1,0],0))).to eq([
            [2,0],[3,0]
          ])
        end
      end

      context 'when an enemy is present on left' do
        subject(:board) { described_class.new([Pawn.new([1,1],0),Pawn.new([2,0],1)]) }

        it 'should return one step and two steps ahead and left diagonal' do
          expect(board.get_valid_moves(board.pieces[0])).to eq([
            [2,1],[3,1],[2,0]
          ])
        end
      end

      context 'when an enemy is present on right' do
        subject(:board) { described_class.new([Pawn.new([4,0],1),Pawn.new([3,0],0),Pawn.new([3,1],0)]) }

        it 'should return one step and two steps ahead and left diagonal' do
          expect(board.get_valid_moves(board.pieces[0])).to eq([
            [3,1]
          ])
        end
      end

      context 'when an enemy is present in front' do
        subject(:board) { described_class.new([Pawn.new([1,1],0),Pawn.new([2,1],1)]) }

        it 'should not return one step and two steps ahead' do
          expect(board.get_valid_moves(board.pieces[0])).to eq([])
        end
      end

      context 'when an enemy is present in front' do
        subject(:board) { described_class.new([Pawn.new([3,0],0),Pawn.new([4,0],1)]) }

        it 'should not return any moves' do
          expect(board.get_valid_moves(board.pieces[0])).to eq([])
        end
      end
    end

    describe 'king' do
      context 'when called on Ke1' do
        it 'should return empty array' do
          expect(board.get_valid_moves(King.new([0,4]))).to eq([])
        end
      end

      context 'when called on Ke4' do
        it 'should return adjacent spaces' do
          expect(board.get_valid_moves(King.new([3,4]))).to eq([[4, 4], [4, 3], [3, 3], [2, 3], [2, 4], [2, 5], [3, 5], [4, 5]])
        end
      end

      context 'when king is in check' do
        subject(:board) { described_class.new([King.new([0,0],0),Rook.new([7,1],1)]) }
        
        it 'should return non-check spaces' do
          expect(board.get_valid_moves(board.pieces[0])).to eq([[1,0]])
        end
      end
    end
  end

  describe '#is_king_in_check?' do
    context 'when king is not in check' do
      it 'returns false' do
        expect(board.is_king_in_check?(0)).to eq(false)
      end
    end

    context 'when king is in check' do
      subject(:board) { described_class.new([King.new([0,0],0), Rook.new([4,0],1)]) }

      it 'returns true' do
        expect(board.is_king_in_check?(0)).to eq(true)
      end
    end
  end

  describe '#is_king_in_checkmate?' do
    context 'when king is not in checkmate' do
      subject(:board) { described_class.new([King.new([0,0],0),Rook.new([7,1],1)]) }

      it 'returns false' do
        expect(board.is_king_in_checkmate?(0)).to eq(false)
      end
    end

    context 'when king is in check, but not checkmate' do
      subject(:board) { described_class.new([King.new([0,0],0),Rook.new([7,0],1)]) }

      it 'returns false' do
        expect(board.is_king_in_checkmate?(0)).to eq(false)
      end
    end

    context 'when king would be in checkmate without a capture' do
      subject(:board) { described_class.new([King.new([0,0],0),Rook.new([7,0],1),Rook.new([7,1],1),Rook.new([3,0],0)]) }

      it 'returns false' do
        expect(board.is_king_in_checkmate?(0)).to eq(false)
      end
    end

    context 'when king would be in checkmate without a pawn capture' do
      subject(:board) { described_class.new([King.new([0,4],0),Queen.new([0,3],0),Bishop.new([0,5],0),Knight.new([0,6],0),Pawn.new([1,3],0),Pawn.new([1,4],0),Pawn.new([1,5],0),Knight.new([2,5],1)]) }

      it 'returns false' do
        expect(board.is_king_in_checkmate?(0)).to eq(false)
      end
    end

    context 'when king is in checkmate' do
      subject(:board) { described_class.new([King.new([0,0],0),Rook.new([7,0],1),Rook.new([7,1],1)]) }

      it 'returns true' do
        expect(board.is_king_in_checkmate?(0)).to eq(true)
      end
    end
  end

  describe '#move' do
    before do
      allow(board).to receive(:print)
    end

    describe 'valid moves' do
      context 'when called on starting pawn' do
        subject(:board) { described_class.new([Pawn.new([1,0],0)]) }

        it 'changes a2 pawn position to a4' do
          expect { board.move('',0,3) }.to change { board.pieces[0].position }.to([3,0])
        end

        it 'removes double jump from pawn' do
          expect { board.move('',0,3) }.to change { board.pieces[0].possible_moves }.to([[1,0]])
        end
      end

      context 'when called on promotable pawn' do
        subject(:board) { described_class.new([Pawn.new([6,0],0)]) }

        it 'calls promote pawn' do
          expect(board).to receive(:promote_pawn)
          board.move('',0,7)
        end
      end

      context 'when called on a rook' do
        subject(:board) { described_class.new([Rook.new([0,0],0)]) }

        it 'changes a1 rook position to a4' do
          expect { board.move('R',0,3) }.to change { board.pieces[0].position }.to([3,0])
        end
      end

      context 'when called on a knight' do
        subject(:board) { described_class.new([Knight.new([0,0],0)]) }

        it 'changes a1 knight position to b3' do
          expect { board.move('N',1,2) }.to change { board.pieces[0].position }.to([2,1])
        end
      end

      context 'when called on a bishop' do
        subject(:board) { described_class.new([Bishop.new([0,0],0)]) }

        it 'changes a1 bishop position to c3' do
          expect { board.move('B',2,2) }.to change { board.pieces[0].position }.to([2,2])
        end
      end

      context 'when called on a queen' do
        subject(:board) { described_class.new([Queen.new([0,0],0)]) }

        it 'changes a1 queen position to a4' do
          expect { board.move('Q',0,3) }.to change { board.pieces[0].position }.to([3,0])
        end

        it 'changes a1 queen position to c3' do
          expect { board.move('Q',2,2) }.to change { board.pieces[0].position }.to([2,2])
        end
      end

      context 'when called on a king' do
        subject(:board) { described_class.new([King.new([0,0],0)]) }

        it 'changes a1 king position to a2' do
          expect { board.move('K',0,1) }.to change { board.pieces[0].position }.to([1,0])
        end
      end
    end
  end

  describe '#convert_letter_to_piece' do
    context 'when no letter is input' do
      it 'returns Pawn' do
        expect(board.convert_letter_to_piece('')).to eq(Pawn)
      end
    end

    context 'when R is input' do
      it 'returns Rook' do
        expect(board.convert_letter_to_piece('R')).to eq(Rook)
      end
    end

    context 'when N is input' do
      it 'returns Knight' do
        expect(board.convert_letter_to_piece('N')).to eq(Knight)
      end
    end

    context 'when B is input' do
      it 'returns Bishop' do
        expect(board.convert_letter_to_piece('B')).to eq(Bishop)
      end
    end

    context 'when Q is input' do
      it 'returns Queen' do
        expect(board.convert_letter_to_piece('Q')).to eq(Queen)
      end
    end

    context 'when K is input' do
      it 'returns King' do
        expect(board.convert_letter_to_piece('K')).to eq(King)
      end
    end
  end

  describe '#promote_pawn' do
    before do
      allow(board).to receive(:puts)
      allow(board).to receive(:gets).and_return('Q')
    end

    subject(:board) { described_class.new([Pawn.new([7,0],0)]) }

    it 'puts promotion message' do
      expect(board).to receive(:puts).with("Pawn Promoted! Input Q, B, N, or R.")
      board.promote_pawn(board.pieces[0])
    end

    it 'gets player input' do
      expect(board).to receive(:gets)
      board.promote_pawn(board.pieces[0])
    end

    context 'when K is input' do
      before do
        allow(board).to receive(:gets).and_return('K','Q')
      end

      it 'puts error message' do
        expect(board).to receive(:puts).with("Invalid Input: You cannot promote to a king")
        board.promote_pawn(board.pieces[0])
      end

      it 'calls #promote_pawn again' do
        expect(board).to receive(:promote_pawn)
        board.promote_pawn(board.pieces[0])
      end
    end

    context 'white pawn moves to opposite side' do
      it 'replaces pawn with white queen' do
        expect { board.promote_pawn(board.pieces[0]) }.to change { board.pieces[0].char }.to("♛")
      end
    end

    context 'black pawn moves to opposite side' do
      subject(:board) { described_class.new([Pawn.new([0,0],1)]) }

      it 'replaces pawn with black queen' do
        expect { board.promote_pawn(board.pieces[0]) }.to change { board.pieces[0].char }.to("♕")
      end
    end
  end

  describe '#king_can_castle?' do
    describe 'when white is castling' do
      describe 'with a king-side castle' do
        context 'king can castle' do
          subject(:board) { described_class.new([King.new([0,4],0),Pawn.new([1,5],0),Pawn.new([1,6],0),Pawn.new([1,7],0),Rook.new([0,7],0)]) }

          it 'returns true' do
            expect(board.king_can_castle?('K')).to eq(true)
          end
        end

        context 'king is not in place' do
          subject(:board) { described_class.new([King.new([0,5],0),Pawn.new([1,5],0),Pawn.new([1,6],0),Pawn.new([1,7],0),Rook.new([0,7],0)]) }

          it 'returns false' do
            expect(board.king_can_castle?('K')).to eq(false)
          end
        end

        context 'rook is not in place' do
          subject(:board) { described_class.new([King.new([0,4],0),Pawn.new([1,5],0),Pawn.new([1,6],0),Pawn.new([1,7],0),Rook.new([0,6],0)]) }

          it 'returns false' do
            expect(board.king_can_castle?('K')).to eq(false)
          end
        end

        context 'king is in check' do
          subject(:board) { described_class.new([King.new([0,4],0),Pawn.new([1,5],0),Pawn.new([1,6],0),Pawn.new([1,7],0),Rook.new([0,7],0),Rook.new([3,4],1)]) }

          it 'returns false' do
            expect(board.king_can_castle?('K')).to eq(false)
          end
        end

        context 'castling goes through check' do
          subject(:board) { described_class.new([King.new([0,4],0),Pawn.new([1,5],0),Pawn.new([1,6],0),Pawn.new([1,7],0),Rook.new([0,7],0),Bishop.new([3,2],1)]) }

          it 'returns false' do
            expect(board.king_can_castle?('K')).to eq(false)
          end
        end

        context 'castling would put king in check' do
          subject(:board) { described_class.new([King.new([0,4],0),Pawn.new([1,6],0),Pawn.new([1,7],0),Rook.new([0,7],0),Bishop.new([3,3],1)]) }

          it 'returns false' do
            expect(board.king_can_castle?('K')).to eq(false)
          end
        end
      end

      describe 'queen-side castle' do
        context 'white king can castle' do
          subject(:board) { described_class.new([King.new([0,4],0),Pawn.new([1,0],0),Pawn.new([1,1],0),Pawn.new([1,2],0),Rook.new([0,0],0)]) }

          it 'returns true' do
            expect(board.king_can_castle?('Q')).to eq(true)
          end
        end

        context 'king is not in place' do
          subject(:board) { described_class.new([King.new([0,5],0),Pawn.new([1,0],0),Pawn.new([1,1],0),Pawn.new([1,2],0),Rook.new([0,0],0)]) }

          it 'returns false' do
            expect(board.king_can_castle?('Q')).to eq(false)
          end
        end

        context 'rook is not in place' do
          subject(:board) { described_class.new([King.new([0,4],0),Pawn.new([1,0],0),Pawn.new([1,1],0),Pawn.new([1,2],0),Rook.new([0,1],0)]) }

          it 'returns false' do
            expect(board.king_can_castle?('Q')).to eq(false)
          end
        end

        context 'king is in check' do
          subject(:board) { described_class.new([King.new([0,4],0),Pawn.new([1,0],0),Pawn.new([1,1],0),Pawn.new([1,2],0),Rook.new([0,0],0),Rook.new([3,4],1)]) }

          it 'returns false' do
            expect(board.king_can_castle?('Q')).to eq(false)
          end
        end

        context 'castling goes through check' do
          subject(:board) { described_class.new([King.new([0,4],0),Pawn.new([1,0],0),Pawn.new([1,1],0),Pawn.new([1,2],0),Rook.new([0,0],0),Bishop.new([3,6],1)]) }

          it 'returns false' do
            expect(board.king_can_castle?('Q')).to eq(false)
          end
        end

        context 'castling would put king in check' do
          subject(:board) { described_class.new([King.new([0,4],0),Pawn.new([1,0],0),Pawn.new([1,1],0),Pawn.new([1,2],0),Rook.new([0,0],0),Bishop.new([3,5],1)]) }

          it 'returns false' do
            expect(board.king_can_castle?('Q')).to eq(false)
          end
        end
      end
    end
    describe 'when black is castling' do
      describe 'with a king-side castle' do
        context 'king can castle' do
          subject(:board) { described_class.new([King.new([7,4],1),Pawn.new([6,5],1),Pawn.new([6,6],1),Pawn.new([6,7],1),Rook.new([7,7],1)],1) }

          it 'returns true' do
            expect(board.king_can_castle?('K')).to eq(true)
          end
        end

        context 'king is not in place' do
          subject(:board) { described_class.new([King.new([7,5],1),Pawn.new([6,5],1),Pawn.new([6,6],1),Pawn.new([6,7],1),Rook.new([7,7],1)],1) }

          it 'returns false' do
            expect(board.king_can_castle?('K')).to eq(false)
          end
        end

        context 'rook is not in place' do
          subject(:board) { described_class.new([King.new([7,4],1),Pawn.new([6,5],1),Pawn.new([6,6],1),Pawn.new([6,7],1),Rook.new([7,6],1)],1) }

          it 'returns false' do
            expect(board.king_can_castle?('K')).to eq(false)
          end
        end

        context 'king is in check' do
          subject(:board) { described_class.new([King.new([7,4],1),Pawn.new([6,5],1),Pawn.new([6,6],1),Pawn.new([6,7],1),Rook.new([7,7],1),Rook.new([3,4],0)],1) }

          it 'returns false' do
            expect(board.king_can_castle?('K')).to eq(false)
          end
        end

        context 'castling goes through check' do
          subject(:board) { described_class.new([King.new([7,4],1),Pawn.new([6,5],1),Pawn.new([6,6],1),Pawn.new([6,7],1),Rook.new([7,7],1),Bishop.new([4,2],0)],1) }

          it 'returns false' do
            expect(board.king_can_castle?('K')).to eq(false)
          end
        end

        context 'castling would put king in check' do
          subject(:board) { described_class.new([King.new([7,4],1),Pawn.new([6,6],1),Pawn.new([6,7],0),Rook.new([7,7],1),Bishop.new([4,3],0)],1) }

          it 'returns false' do
            expect(board.king_can_castle?('K')).to eq(false)
          end
        end
      end

      describe 'with a queen-side castle' do
        context 'king can castle' do
          subject(:board) { described_class.new([King.new([7,4],1),Pawn.new([6,0],1),Pawn.new([6,1],1),Pawn.new([6,2],1),Rook.new([7,0],1)],1) }

          it 'returns true' do
            expect(board.king_can_castle?('Q')).to eq(true)
          end
        end

        context 'king is not in place' do
          subject(:board) { described_class.new([King.new([7,5],1),Pawn.new([6,0],1),Pawn.new([6,1],1),Pawn.new([6,2],1),Rook.new([7,0],1)],1) }

          it 'returns false' do
            expect(board.king_can_castle?('Q')).to eq(false)
          end
        end

        context 'rook is not in place' do
          subject(:board) { described_class.new([King.new([7,4],1),Pawn.new([6,0],1),Pawn.new([6,1],1),Pawn.new([6,2],1),Rook.new([7,1],1)],1) }

          it 'returns false' do
            expect(board.king_can_castle?('Q')).to eq(false)
          end
        end

        context 'king is in check' do
          subject(:board) { described_class.new([King.new([7,4],1),Pawn.new([6,0],1),Pawn.new([6,1],1),Pawn.new([6,2],1),Rook.new([7,0],1),Rook.new([3,4],0)],1) }

          it 'returns false' do
            expect(board.king_can_castle?('Q')).to eq(false)
          end
        end

        context 'castling goes through check' do
          subject(:board) { described_class.new([King.new([7,4],1),Pawn.new([6,0],1),Pawn.new([6,1],1),Pawn.new([6,2],1),Rook.new([7,0],1),Bishop.new([3,7],0)],1) }

          it 'returns false' do
            expect(board.king_can_castle?('Q')).to eq(false)
          end
        end

        context 'castling would put king in check' do
          subject(:board) { described_class.new([King.new([7,4],1),Pawn.new([6,0],1),Pawn.new([6,1],1),Pawn.new([6,2],1),Rook.new([7,0],1),Bishop.new([3,6],0)],1) }

          it 'returns false' do
            expect(board.king_can_castle?('Q')).to eq(false)
          end
        end
      end
    end
  end
end