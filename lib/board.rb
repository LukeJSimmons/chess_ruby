require 'piece'

class Board
  attr_reader :board, :pieces

  def initialize(board=[
    ['#','#','#','#','#','#','#','#'],
    ['#','#','#','#','#','#','#','#'],
    ['#','#','#','#','#','#','#','#'],
    ['#','#','#','#','#','#','#','#'],
    ['#','#','#','#','#','#','#','#'],
    ['#','#','#','#','#','#','#','#'],
    ['#','#','#','#','#','#','#','#'],
    ['#','#','#','#','#','#','#','#']
  ])
    @board = board
    @pieces = self.setup_pieces
  end

  def setup_pieces
    init_positions = [['R','N','B','Q','K','B','N','R'],['','','','','','','','']] # Acts as a key for the loops to place the correct pieces
    pieces_arr = []

    row = 0
    until row > 1 do
      column = 0
      until column > 7 do
        pieces_arr << Piece.new([row,column],0,init_positions[row][column])
        column += 1
      end
      row += 1
    end

    row = 7
    until row < 6 do
      column = 0
      until column > 7 do
        pieces_arr << Piece.new([row,column],1,init_positions[(row-7).abs][column]) # Converts 7 and 6 to 0 and 1 for array
        column += 1
      end
      row -= 1
    end

    pieces_arr
  end

  def print(board=@board)
    board_str = ''
    
    row = 7
    until row < 0 do # Loop moves bottom to top to keep 0,0 in the bottom left
      board_str << "\n"
      column = 0
      until column > 7 do
        piece_on_position = pieces.filter { |piece| piece.position == [row,column] }[0] # Checks if any piece's position matches the position being printed
        piece_on_position ? board_str << piece_on_position.char + ' ' : board_str << '# '
        column += 1
      end
      row -= 1
    end

    puts board_str
  end
end