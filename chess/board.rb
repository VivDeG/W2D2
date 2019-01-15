require_relative "piece"

class Board
  attr_reader :grid
  
  def initialize(grid = Array.new(8) { Array.new(8) })
    @grid = grid
    populate

  end

  def populate
    self.grid[0].each_with_index do |square, i|
      self.grid[0][i] = Piece.new
    end
    self.grid[1].each_with_index do |square, i|
      self.grid[1][i] = Piece.new
    end

    null_pieces = Array.new(4) { Array.new(8, NullPiece.new) }
    self.grid[2..5] = null_pieces

    self.grid[6].each_with_index do |square, i|
      self.grid[6][i] = Piece.new
    end
    self.grid[7].each_with_index do |square, i|
      self.grid[7][i] = Piece.new
    end
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
end