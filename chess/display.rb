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
      row.each_with_index do |col, j|
        case col.symbol
        when :rook
          el = " R ".black
        when :knight
          el = " H ".black
        when :bishop
          el = " B ".black
        when :queen
          el = " Q ".black
        when :king
          el = " K ".black
        when :pawn
          el = " p ".black
        when :nil
          el = "   "
        end
        
        if (i.even? && j.even?) || (i.odd? && j.odd?)
          el = el.on_light_blue
        else
          el = el.on_blue
        end

        if [i, j] == cursor.cursor_pos
          el = el.white.on_magenta
        end
        print el
      end
      puts
    end
    puts
  end

  def render_cursor
    while true
      system("clear")
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