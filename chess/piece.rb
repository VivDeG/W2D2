require "byebug"
require "singleton"

module SlidingPiece
  HORIZONTAL_DIR = {
    up: [-1, 0],
    down: [1, 0],
    left: [0, -1],
    right: [0, 1]
  }

  DIAGONAL_DIR = {
    up_left: [-1, -1],
    up_right: [-1, 1],
    down_left: [1, -1],
    down_right: [1, 1]
  }

  def moves
    dirs = []
    if move_dirs == "horizontal"
      move_array = HORIZONTAL_DIR.values
    elsif move_dirs == "diagonal"
      move_array = DIAGONAL_DIR.values
    elsif move_dirs == "both"
      move_array = HORIZONTAL_DIR.values + DIAGONAL_DIR.values
    end

    move_array.each do |slide|
      start = pos.dup
      while board.valid_pos?(start) && board[start].is_a?(NullPiece)
        start[0] += slide[0]
        start[1] += slide[1]
        dirs << start.dup
      end
      dirs.pop unless board[start].color != self.color
    end
    dirs
  end

  def get_dirs
    arr = move_dirs
    p arr
  end

  def move_dirs
  end

end

module SteppingPiece

  def moves
    steps = []
    move_diffs.each do |step|
      start = pos.dup
      start[0] += step[0]
      start[1] += step[1]
      steps << start.dup if board.valid_pos?(start)
    end
    steps
  end

  def move_diffs
  end

end

class Piece
  attr_reader :pos, :board, :color, :symbol

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
  end

  def moves
  end

end

class Bishop < Piece
  include SlidingPiece

  def initialize(pos, board, color)
    @symbol = :bishop
    super
  end

  def move_dirs
    str = "diagonal"
  end
end

class Rook < Piece
  include SlidingPiece

  def initialize(pos, board, color)
    @symbol = :rook
    super
  end

  def move_dirs
    "horizontal"
  end
end

class Queen < Piece
  include SlidingPiece

  def initialize(pos, board, color)
    @symbol = :queen
    super
  end

  def move_dirs
    str = "both"
  end
end

class Knight < Piece
  include SteppingPiece

  MOVES = {
    up_up_left: [-2, -1],
    up_up_right: [-2, 1],
    up_left_left: [-1, -2],
    up_right_right: [-1, 2],
    down_down_left: [2, -1],
    down_down_right: [2, 1],
    down_left_left: [1, -2],
    down_right_right: [1, 2]
  }

  def initialize(pos, board, color)
    @symbol = :knight
    super
  end

  def move_diffs
    MOVES.values
  end
end

class King < Piece
  include SteppingPiece

  MOVES = {
    left: [0, -1],
    right: [0, 1],
    up: [-1, 0],
    down: [1, 0],
    up_left: [-1, -1],
    up_right: [-1, 1],
    down_left: [1, -1],
    down_right: [1, 1]
  }

  def initialize(pos, board, color)
    @symbol = :king
    super
  end

  def move_diffs
    MOVES.values
  end
end

class Pawn < Piece

  def initialize(pos, board, color)
    @symbol = :pawn
    super
  end

  def moves
    move_dirs
  end

  def move_dirs
    forward_steps + side_attacks
  end

  def at_start_row?
    return true if (pos[0] == 1 && forward_dir == 1) || (pos[0] == 6 && forward_dir == -1)
    false
  end

  def forward_dir
    if self.color == :black
      return 1
    else
      return -1
    end
  end

  def forward_steps
    steps = []
    start = pos.dup
    start[0] += forward_dir
    steps << start.dup if board[start].is_a?(NullPiece)
    if at_start_row?
      start[0] += forward_dir
      steps << start
    end
    steps
  end

  def side_attacks
    attacks = []
    start = pos.dup
    start[0] += forward_dir
    left_attack = [start[0], start[1] - 1]
    right_attack = [start[0], start[1] + 1]
    attacks << left_attack unless board[left_attack].is_a?(NullPiece) || board[left_attack].nil?
    attacks << right_attack unless board[right_attack].is_a?(NullPiece) || board[right_attack].nil?
    attacks
  end
  
end

class NullPiece < Piece
  include Singleton

  def initialize
    @symbol = :nil
  end

  def moves
  end
  
end