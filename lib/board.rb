require_relative 'pawn'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'

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
        case init_positions[row][column]
        when ''
          pieces_arr << Pawn.new([row,column],0)
        when 'R'
          pieces_arr << Rook.new([row,column],0)
        when 'N'
          pieces_arr << Knight.new([row,column],0)
        when 'B'
          pieces_arr << Bishop.new([row,column],0)
        when 'Q'
          pieces_arr << Queen.new([row,column],0)
        when 'K'
          pieces_arr << King.new([row,column],0)
        end
        
        column += 1
      end
      row += 1
    end

    row = 7
    until row < 6 do
      column = 0
      until column > 7 do
        case init_positions[(row-7).abs][column]
        when ''
          pieces_arr << Pawn.new([row,column],1)
        when 'R'
          pieces_arr << Rook.new([row,column],1)
        when 'N'
          pieces_arr << Knight.new([row,column],1)
        when 'B'
          pieces_arr << Bishop.new([row,column],1)
        when 'Q'
          pieces_arr << Queen.new([row,column],1)
        when 'K'
          pieces_arr << King.new([row,column],1)
        end
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

  def take_input
    input = gets
    self.move(input)
  end

  def move(new_position)
    valid_piece = self.pieces.filter { |piece| piece.possible_moves.include?(new_position) }
  end
end