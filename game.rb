require_relative 'cell'

class Game
  attr_accessor :cells
  def initialize(rows = 3, cols = 3)
    @cells = []
    @nrows = rows
    @ncols = cols
  end

  def add_cells(*cells_to_add)
    @cells += cells_to_add
  end

  def tick
    @cells.each { |cell| cell.decide }
    @cells.each { |cell| cell.apply }
  end

  def max
    @nrows * @ncols
  end

  def ncells
    @cells.size
  end

  def nliving
    @cells.count { |x| x.alive? }
  end

  def steady_state
    @cells.count { |x| !x.changed } == 0
  end

  def add(is_alive)
    raise 'too many cells' if ncells >= max
    cell = Cell.new(is_alive)
    i = ncells
    @cells << cell

    cell.attach(@cells[northeast_neighbor_index(i)], :northeast) if northeast_neighbor_index(i)
    cell.attach(@cells[north_neighbor_index(i)], :north) if north_neighbor_index(i)
    cell.attach(@cells[northwest_neighbor_index(i)], :northwest) if northwest_neighbor_index(i)
    cell.attach(@cells[west_neighbor_index(i)], :west) if west_neighbor_index(i)
  end

  def pprint
    @cells.each_with_index do |cell, i|
      print cell.alive? ? 'x' : '.'
      puts if (i+1) % @ncols == 0
    end
    puts
  end

  def northeast_neighbor_index(i)
    return nil if i < @ncols
    return nil if (i+1) % @ncols == 0
    @ncols * (i / @ncols - 1) + i % @ncols + 1
  end

  def north_neighbor_index(i)
    return nil if i < @ncols
    @ncols * (i / @ncols - 1) + i % @ncols
  end

  def northwest_neighbor_index(i)
    return nil if i < @ncols
    return nil if i % @ncols == 0
    (i / @ncols - 1)* @ncols + (i % @ncols - 1)
  end

  def west_neighbor_index(i)
    return nil if i % @ncols == 0
    i - 1
  end
end
