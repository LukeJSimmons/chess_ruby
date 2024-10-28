require_relative 'pawn'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'

class Board
  attr_reader :board, :pieces

  def initialize(pieces=self.setup_pieces)
    @board = [
      ['#','#','#','#','#','#','#','#'],
      ['#','#','#','#','#','#','#','#'],
      ['#','#','#','#','#','#','#','#'],
      ['#','#','#','#','#','#','#','#'],
      ['#','#','#','#','#','#','#','#'],
      ['#','#','#','#','#','#','#','#'],
      ['#','#','#','#','#','#','#','#'],
      ['#','#','#','#','#','#','#','#']
    ]
    @pieces = pieces
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
    self.take_input
  end

  def take_input
    input = gets.chomp

    exit if input == 'q'

    split_input = input.split('')
    if split_input.length > 2
      piece = split_input[0]
      x = split_input[1].ord-97
      y = split_input[2].to_i-1
    else
      piece = ''
      x = split_input[0].ord-97
      y = split_input[1].to_i-1
    end
    self.move(piece,x,y)
  end

  def get_valid_moves(piece)
    if piece.instance_of?(Rook) || piece.instance_of?(Bishop) || piece.instance_of?(Queen)
      return self.get_valid_line_moves(piece)
    end
    
    valid_moves = []
    piece.possible_moves.map do |possible_move|
      y_position = possible_move[0] + piece.position[0]
      x_position = possible_move[1] + piece.position[1]

      is_on_board = y_position.between?(0, 7) && x_position.between?(0, 7)

      is_enemy_piece = @pieces.any? { |other_piece| other_piece.position == [y_position,x_position] && other_piece.color != piece.color }

      is_friendly_piece = @pieces.any? { |other_piece| other_piece.position == [y_position,x_position] && other_piece.color == piece.color }

      valid_moves << [y_position,x_position] if is_on_board && !is_friendly_piece
    end
    valid_moves
  end

  def get_valid_line_moves(piece)
    valid_moves = []

    directions = piece.possible_moves

    directions.each do |direction|
      direction_moves = []

      y, x = piece.position

      loop do
        y += direction[0]
        x += direction[1]

        break unless y.between?(0, 7) && x.between?(0, 7)

        position = [y, x]

        if @pieces.any? { |other_piece| other_piece.position == position && other_piece.color == piece.color }
          break
        elsif @pieces.any? { |other_piece| other_piece.position == position && other_piece.color != piece.color }
          direction_moves << position
          break
        else
          direction_moves << position
        end
      end

      valid_moves.concat(direction_moves)
    end
    
    valid_moves
  end

  def is_king_in_check?(color)
    king = @pieces.filter { |piece| piece.instance_of?(King) && piece.color == color }[0]
    enemy_pieces = @pieces.filter { |piece| piece.color != color }

    is_in_check = enemy_pieces.any? do |enemy_piece|
      self.get_valid_moves(enemy_piece).include?(king.position)
    end

    is_in_check
  end

  def move(piece_letter,x,y)
    piece_class = self.convert_letter_to_piece(piece_letter)
    valid_piece = @pieces.filter { |piece| piece.instance_of?(piece_class) && get_valid_moves(piece).include?([y,x]) }[0]

    if valid_piece
      valid_piece.remove_double_move if valid_piece.instance_of?(Pawn)
      valid_piece.position = [y,x]
    else
      puts 'Invalid input: Please try again'
    end
    self.print
  end

  def convert_letter_to_piece(letter)
    case letter
    when ''
      Pawn
    when 'R'
      Rook
    when 'N'
      Knight
    when 'B'
      Bishop
    when 'Q'
      Queen
    when 'K'
      King
    end
  end
end