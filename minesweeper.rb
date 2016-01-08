class Minesweeper

end

class Board
  attr_accessor :grid
  def def initialize
    @grid = Array.new(9) {Array.new(9,*)}
  end

  def place_bombs
    bomb_placed = 0

    while bomb_placed < 40
      randx = rand(0..8)
      randy = rand(0..8)

      @grid

    end
  end
end
