require_relative "piece"

class Board
  attr_reader :grid
  
  def initialize(grid = Array.new(8) { Array.new(8) })
    @grid = grid
    populate

  end

  def populate
    self.grid.each_with_index do |row, i|
      case i
      when 0
        self.grid[i] = populate_row(i, :black)
      when 1
        8.times do |j|
          self.grid[i][j] = Pawn.new([i, j], self, :black)
        end
      when (2..5)
        8.times do |j|
          self.grid[i][j] = NullPiece.instance
        end
      when 6
        8.times do |j|
          self.grid[i][j] = Pawn.new([i, j], self, :white)
        end
      when 7
        self.grid[i] = populate_row(i, :white)
      end
    end




    # self.grid[0].each_with_index do |row, i|
    #   self.grid[0][i] = Piece.new([0, i], self, :black)
    # end
    # self.grid[1].each_with_index do |row, i|
    #   self.grid[1][i] = Piece.new([1, i], self, :black)
    # end

    # null_pieces = Array.new(4) { Array.new(8, NullPiece.instance) }
    # self.grid[2..5] = null_pieces

    # self.grid[6].each_with_index do |row, i|
    #   self.grid[6][i] = Piece.new([6, i], self, :white)
    # end
    # self.grid[7].each_with_index do |row, i|
    #   self.grid[7][i] = Piece.new([7, i], self, :white)
    # end
  end

  def populate_row(row, color)
    pieces = Array.new(8)

    pieces.each_index do |i|
      case i
      when 0
        pieces[i] = Rook.new([row, i], self, color)
      when 1
        pieces[i] = Knight.new([row, i], self, color)
      when 2
        pieces[i] = Bishop.new([row, i], self, color)
      when 3
        pieces[i] = Queen.new([row, i], self, color)
      when 4
        pieces[i] = King.new([row, i], self, color)
      when 5
        pieces[i] = Bishop.new([row, i], self, color)
      when 6
        pieces[i] = Knight.new([row, i], self, color)
      when 7
        pieces[i] = Rook.new([row, i], self, color)
      end
    end
    pieces
  end

  def move_piece(start_pos, end_pos)
    raise "There is no piece here." if self[start_pos].is_a?(NullPiece)
    raise "Can not move there." if valid_pos?(pos)
    self[end_pos], self[start_pos] = self[start_pos], NullPiece.new
  end

  def valid_pos?(pos)
    if pos.first < 0 || pos.first > 7 || pos.last < 0 || pos.last > 7
      return false
    end
    true
  end

  def [](pos)
    row, col = pos
    self.grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    self.grid[row][col] = value
  end

  def in_check?(color)
    self.grid.each_with_index do |row, i|
      row.each_with_index do |square, j|
        square.moves.each do |move|
          return true if self[move]is_a?(King) && self[move].color != color
        end
      end
    end
    false
  end

  def checkmate?(color)
    if in_check?(color)
      
  end

end