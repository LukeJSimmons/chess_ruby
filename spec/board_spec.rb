require './lib/board'
require './lib/piece'

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

  describe '#pieces' do
    context 'when game starts' do
      it 'should return all 32 pieces' do
        expect(board.pieces.length).to eq(32)
      end

      it 'should return Piece instances' do
        expect(board.pieces.all? { |piece| piece.instance_of? Piece }).to eq(true)
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
    context 'when game starts' do
      it 'displays starting board correctly' do
        expect(board).to receive(:puts).with("\n♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖ \n♙ ♙ ♙ ♙ ♙ ♙ ♙ ♙ \n# # # # # # # # \n# # # # # # # # \n# # # # # # # # \n# # # # # # # # \n♟ ♟ ♟ ♟ ♟ ♟ ♟ ♟ \n♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜ ")
        board.print
      end
    end
  end
end