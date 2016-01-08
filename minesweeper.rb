require "byebug"
class Minesweeper

    def initialize(player)
      @player = player
      @gameboard = Board.new
    end

    def play
      playturn until gameover?
    end

    def playturn
      @gameboard.display
      @gameboard.player_display
      move = @player.get_move
      make_move(move)

    end

    def make_move(move)
      letter = move[1]
      pos = move[0]
      tile_pos = @gameboard.grid[pos[0]][pos[1]]
      #debugger
      if letter == "f"
        tile_pos.flag
      else
        tile_pos.reveal if tile_pos.flagged == false
      end
    end

    def gameover?
      if @gameboard.grid.flatten.count{|tile| tile.hidden == false} == (81 - @gameboard.numberofbombs)
        puts " gratz you win"
        exit
      elsif @gameboard.grid.flatten.any? {|tile| tile.hidden == false && tile.symbol == :b }
        puts "you suck at this #{@player.name}"
        exit
      end
      false
    end
end

class Tile
  attr_accessor :symbol, :flagged, :hidden
  def initialize
    @symbol = :*
    @flagged = false
    @hidden = true
  end

  def reveal
    @hidden = false if @flagged == false
  end

  def flag
    if @flagged == false
      @flagged = true
    else
      @flagged = false
    end
  end

  def show_player
    if hidden && flagged
      return :F
    elsif hidden
      return :*
    else
      return @symbol
    end
  end

end

class Board
  attr_accessor :grid
  attr_reader :numberofbombs
  def initialize
    # debugger
    @numberofbombs = 30
    @grid = Array.new(9) {Array.new(9) {Tile.new}}
    place_bombs
    place_bomb_indicators
  end

  def place_bombs
    bomb_placed = 0

    while bomb_placed < numberofbombs
      randx = rand(0..8)
      randy = rand(0..8)

      if @grid[randx][randy].symbol != :b
        @grid[randx][randy].symbol = :b
        bomb_placed += 1
      end

    end
  end

  def place_bomb_indicators
    @grid.each_with_index do |row,idx1|
      row.each_with_index do |col,idx2|
        count = count_adj_bombs([idx1,idx2])
        @grid[idx1][idx2].symbol = count if @grid[idx1][idx2].symbol != :b
      end
    end

  end

  def count_adj_bombs(pos)
    row = pos[0]
    col = pos[1]
    adjacent_spots =
    { left: [row, col - 1],
      right: [row, col + 1],
      top: [row + 1, col],
      bot: [row - 1, col]
    }

    count = adjacent_spots.values.select do |spot|
        spot[0].between?(0, 8) && spot[1].between?(0, 8) && @grid[spot[0]][spot[1]].symbol == :b
      end

      count.length
  end

  def display
    @grid.each{|row| p row.map {|pos| pos.symbol}}
  end

  def player_display
    @grid.each{|row| p row.map {|pos| pos.show_player}}
  end
end

class Player
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def get_move
    puts "Enter a move (e.g. 0 0 f)"
    move = gets.chomp
    letter = move.scan(/[a-z]/).join
    number = move.scan(/[0-9]/).map(&:to_i)

    if valid_move?(number,letter)
      return [number,letter]
    else
      get_move
    end

  end

  def valid_move?(number,letter)
    if (letter == "f" || letter == "") && number.length == 2 && number[0].between?(0,8) && number[1].between?(0,8)
      return true
    else
      return false
    end
  end

end

# board = Board.new
# board.place_bombs
# board.display
# board.place_bomb_indicators
# board.display
# board.player_display
# player = Player.new("Ryan")
# player.get_move
# board.count_adj_bombs([5,5])
player = Player.new("Ryan")
game = Minesweeper.new(player)
game.play
