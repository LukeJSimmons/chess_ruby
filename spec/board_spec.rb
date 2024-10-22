require './lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#print' do
    context 'when game starts' do
      it 'displays starting board correctly' do
        expect(board).to receive(:puts).with("\n♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜\n♟ ♟ ♟ ♟ ♟ ♟ ♟ ♟\n# # # # # # # #\n# # # # # # # #\n# # # # # # # #\n# # # # # # # #\n♙ ♙ ♙ ♙ ♙ ♙ ♙ ♙\n♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖")
        board.print
      end
    end

    context 'when in the middle of a game' do
      subject(:board) { described_class.new([
        ['♖','♘','♗','♕','♔','♗','♘','♖'],
        ['♙','♙','#','♙','♙','♙','♙','♙'],
        ['#','#','#','#','#','#','#','#'],
        ['#','#','♙','#','#','#','#','#'],
        ['#','♟','#','#','#','#','#','#'],
        ['#','#','♞','#','#','#','#','#'],
        ['♟','#','♟','♟','♟','♟','♟','♟'],
        ['♜','#','♝','♛','♚','♝','♞','♜']
      ]) }

      it 'displays board correctly' do
        expect(board).to receive(:puts).with("\n♜ # ♝ ♛ ♚ ♝ ♞ ♜\n♟ # ♟ ♟ ♟ ♟ ♟ ♟\n# # ♞ # # # # #\n# ♟ # # # # # #\n# # ♙ # # # # #\n# # # # # # # #\n♙ ♙ # ♙ ♙ ♙ ♙ ♙\n♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖")
        board.print
      end
    end
  end
end