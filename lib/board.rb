class Board
  def initialize(board=[
    ['♖','♘','♗','♕','♔','♗','♘','♖'],
    ['♙','♙','♙','♙','♙','♙','♙','♙'],
    ['#','#','#','#','#','#','#','#'],
    ['#','#','#','#','#','#','#','#'],
    ['#','#','#','#','#','#','#','#'],
    ['#','#','#','#','#','#','#','#'],
    ['♟','♟','♟','♟','♟','♟','♟','♟'],
    ['♜','♞','♝','♛','♚','♝','♞','♜']
  ])
    @board = board
  end

  def print(board=@board) # I will need to refactor this to check if a piece exists at the given position
    board_str = ''
    
    board.reverse.each do |row|
      board_str << "\n"
      board_str << row.join(' ')
    end

    puts board_str
  end
end