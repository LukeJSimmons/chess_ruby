require 'yaml'

require_relative 'pawn'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'

class Board
  attr_reader :board, :pieces

  def initialize(pieces=self.setup_pieces, current_color=0)
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
    @current_color = current_color
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
      board_str << "#{row+1} "
      column = 0
      until column > 7 do
        piece_on_position = pieces.find { |piece| piece.position == [row,column] } # Checks if any piece's position matches the position being printed
        piece_on_position ? board_str << piece_on_position.char + ' ' : board_str << '# '
        column += 1
      end
      row -= 1
    end

    board_str << "\n  a b c d e f g h "

    puts board_str
    self.take_input
  end

  def take_input
    if is_king_in_checkmate?(@current_color)
      puts "#{@current_color == 1 ? 'White' : 'Black'} Wins!"
      exit
    end

    puts "#{@current_color == 0 ? 'White' : 'Black'}'s Turn"
    input = gets.chomp

    exit if input == 'quit' || input == 'q'

    if input == '0-0'
      self.move('0','-','0')
      return
    elsif input == '0-0-0'
      self.move('0-0','-','0')
      return
    end

    return self.save_game if input == 'save' || input == 's'
    return self.load_game if input == 'load' || input == 'l'

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

  def get_valid_moves(piece, check_for_check=true)
    if piece.instance_of?(Rook) || piece.instance_of?(Bishop) || piece.instance_of?(Queen)
      return self.get_valid_line_moves(piece, check_for_check)
    elsif piece.instance_of?(Pawn)
      self.get_valid_pawn_moves(piece)
    end
    
    valid_moves = []
    
    piece.possible_moves.each do |possible_move|
      y_position = possible_move[0] + piece.position[0]
      x_position = possible_move[1] + piece.position[1]

      is_on_board = y_position.between?(0, 7) && x_position.between?(0, 7)

      is_friendly_piece = @pieces.any? { |other_piece| other_piece.position == [y_position,x_position] && other_piece.color == piece.color }

      position = [y_position,x_position]

      original_position = piece.position
      captured_piece = capture_piece_at(position)
      piece.position = position

      king_in_check = is_king_in_check?(piece.color) if check_for_check
      restore_captured_piece(captured_piece)
      piece.position = original_position

      valid_moves << [y_position,x_position] if is_on_board && !is_friendly_piece && !king_in_check
    end

    valid_moves
  end

  def get_valid_line_moves(piece, check_for_check)
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

        original_position = piece.position
        captured_piece = capture_piece_at(position)
        piece.position = position

        king_in_check = is_king_in_check?(piece.color) if check_for_check
        restore_captured_piece(captured_piece)
        piece.position = original_position

        if @pieces.any? { |other_piece| other_piece.position == position && other_piece.color == piece.color }
          break
        elsif @pieces.any? { |other_piece| other_piece.position == position && other_piece.color != piece.color }
          direction_moves << position
          break
        elsif !king_in_check
          direction_moves << position
        end
      end

      valid_moves.concat(direction_moves)
    end
    
    valid_moves
  end

  def get_valid_pawn_moves(piece)
    piece.possible_moves = []

    y = piece.position[0]
    x = piece.position[1]

    position = [y,x]
    in_front = [[1,0],[-1,0]][piece.color]
    in_front_position = [[y+1,x],[y-1,x]][piece.color]

    double_step = [[2,0],[-2,0]][piece.color]
    double_step_position = [[y+2,x],[y-2,x]][piece.color]

    left_diagonal = [[1,-1],[-1,-1]][piece.color]
    left_diagonal_position = [[y+1,x-1],[y-1,x-1]][piece.color]

    right_diagonal = [[1,1],[-1,1]][piece.color]
    right_diagonal_position = [[y+1,x+1],[y-1,x+1]][piece.color]

    front_is_empty = @pieces.none? { |other_piece| other_piece.position == in_front_position && other_piece.color != piece.color }
    is_first_move = y == [1,6][piece.color]
    left_diagonal_is_enemy = @pieces.any? { |other_piece| other_piece.position == left_diagonal_position && other_piece.color != piece.color }
    right_diagonal_is_enemy = @pieces.any? { |other_piece| other_piece.position == right_diagonal_position && other_piece.color != piece.color }

    piece.possible_moves << in_front if front_is_empty
    piece.possible_moves << double_step if is_first_move && front_is_empty
    piece.possible_moves << left_diagonal if left_diagonal_is_enemy
    piece.possible_moves << right_diagonal if right_diagonal_is_enemy
  end

  def is_king_in_check?(color)
    king = @pieces.find { |piece| piece.instance_of?(King) && piece.color == color }
    
    return false unless king

    enemy_pieces = @pieces.filter { |piece| piece.color != color }

    is_in_check = enemy_pieces.any? do |enemy_piece|
      self.get_valid_moves(enemy_piece, false).include?(king.position) if king
    end

    is_in_check
  end

  def is_king_in_checkmate?(color)
    king = @pieces.find { |piece| piece.instance_of?(King) && piece.color == color }

    return false unless king

    attacker = @pieces.find { |piece| get_valid_moves(piece).include?(king.position) && piece.color != king.color }

    return false unless attacker

    attacker_is_safe = @pieces.none? { |piece| get_valid_moves(piece).include?(attacker.position) && piece.color != attacker.color }

    # @pieces.each { |piece| p "#{piece.char} - #{get_valid_moves(piece)}" } For debugging valid moves

    self.get_valid_moves(king).length == 0 && is_king_in_check?(color) && attacker_is_safe
  end

  def king_can_castle?(side)
    king = @pieces.find { |p| p.instance_of?(King) && p.position == [[0,4],[7,4]][p.color] && p.color == @current_color }
    left_rook = @pieces.find { |p| p.instance_of?(Rook) && p.position == [[0,0],[7,0]][p.color] && p.color == @current_color }
    right_rook = @pieces.find { |p| p.instance_of?(Rook) && p.position == [[0,7],[7,7]][p.color] && p.color == @current_color }
    rook = side == 'K' ? right_rook : left_rook

    king_is_in_place = king != nil
    rook_is_in_place = rook != nil

    if side == 'K'
      goes_through_check = @pieces.any? { |p| self.get_valid_moves(p).include?([[0,5],[7,5]][@current_color]) && p.color != @current_color }
      would_put_in_check = @pieces.any? { |p| self.get_valid_moves(p).include?([[0,6],[7,6]][@current_color]) && p.color != @current_color }
    else
      goes_through_check = @pieces.any? { |p| self.get_valid_moves(p).include?([[0,3],[7,3]][@current_color]) && p.color != @current_color }
      would_put_in_check = @pieces.any? { |p| self.get_valid_moves(p).include?([[0,2],[7,2]][@current_color]) && p.color != @current_color }
    end

    return true if king_is_in_place && rook_is_in_place && !is_king_in_check?(@current_color) && !goes_through_check && !would_put_in_check
    false
  end

  def move(piece_letter,x,y)
    if piece_letter == '0'
      return puts 'Invalid input: Please try again' unless king_can_castle?('K')
      king = @pieces.find { |p| p.instance_of?(King) && p.color == @current_color }
      rook = @pieces.find { |p| p.instance_of?(Rook) && p.position == [[0,7],[7,7]][@current_color] && p.color == @current_color }

      king.position = [[0,6],[7,6]][@current_color]
      rook.position = [[0,5],[7,5]][@current_color]
    elsif piece_letter == '0-0'
      return puts 'Invalid input: Please try again' unless king_can_castle?('Q')
      king = @pieces.find { |p| p.instance_of?(King) && p.color == @current_color }
      rook = @pieces.find { |p| p.instance_of?(Rook) && p.position == [[0,0],[7,0]][@current_color] && p.color == @current_color }

      king.position = [[0,2],[7,2]][@current_color]
      rook.position = [[0,3],[7,3]][@current_color]
    else
      piece_class = self.convert_letter_to_piece(piece_letter)
      valid_piece = @pieces.find { |piece| piece.instance_of?(piece_class) && get_valid_moves(piece).include?([y,x]) && piece.color == @current_color }

      return puts 'Invalid input: Please try again' unless valid_piece

      captured_piece = capture_piece_at([y, x])

      valid_piece.position = [y,x]

      if valid_piece.instance_of?(Pawn)
        valid_piece.remove_double_move
        self.promote_pawn(valid_piece) if valid_piece.position[0] == [7,0][valid_piece.color]
      end
    end

    @current_color = @current_color == 0 ? 1 : 0

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

  def capture_piece_at(position, color=@current_color)
    captured_piece = @pieces.find { |p| p.position == position && p.color != color }
    @pieces.delete(captured_piece) if captured_piece
    captured_piece
  end

  def restore_captured_piece(piece)
    @pieces << piece if piece
  end

  def promote_pawn(pawn)
    puts "Pawn Promoted! Input Q, B, N, or R."
    input = gets.chomp

    if input == 'K'
      puts "Invalid Input: You cannot promote to a king"
      return self.promote_pawn(pawn)
    end

    removed_pawn = capture_piece_at(pawn.position, pawn.color == 0 ? 1 : 0)
    piece_class = convert_letter_to_piece(input)
    @pieces << piece_class.new(removed_pawn.position, removed_pawn.color)
  end

  def save_game
    save_data = YAML.dump({
      board: @board,
      pieces: @pieces,
      current_color: @current_color
    })
    File.open("save_data.yml", "w") { |file| file.write(save_data)}
    puts "Save Complete! Type load whenever you want to continue your game."
  end

  def load_game
    loaded_data = YAML.load(File.read("save_data.yml"), permitted_classes: [Rook, Knight, Bishop, Queen, King, Pawn, Array, Hash, Symbol])
    @board = loaded_data[:board]
    @pieces = loaded_data[:pieces]
    @current_color = loaded_data[:current_color]
    puts "Load Complete! Welcome back to the game."
    self.print
  end
  
end