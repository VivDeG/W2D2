require_relative "cursor"
require_relative "board"
require "colorize"

class Display
  attr_accessor :cursor, :board

  def initialize(board)
    @cursor = Cursor.new([0,0], board)
    @board = board
  end

  def render
    board.grid.each_with_index do |row, i|
      # str = ""
      row.each_with_index do |col, j|
        if col.is_a? NullPiece
          el = "x" 
        else
          el = "O"
        end
        if [i, j] == cursor.cursor_pos
          el = el.colorize(:blue)
        end
        print el
        # str << el
      end
      # puts str
      puts
    end
    # cursor.get_input
  end

  def render_cursor
    while true
      render
      cursor.get_input
    end
  end

end

if $PROGRAM_NAME == __FILE__
  board = Board.new
  display = Display.new(board)
  display.render_cursor
end