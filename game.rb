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

  def pprint
    @cells.each_with_index do |cell, i|
      print cell.alive? ? 'x' : '.'
      puts if (i+1) % @ncols == 0
    end
    puts
  end

  def get_edge(cell, direction)
    tmp = []
    begin
      tmp << cell
      cell = cell.send(direction)
    end while cell
    tmp
  end

  def north_edge
    @north_edge ||= get_edge(@first_cell, :east)
  end

  def west_edge
    @west_edge ||= get_edge(@first_cell, :south)
  end

  def east_edge
    @east_edge ||= get_edge(north_edge.last, :south)
  end

  def south_edge
    @south_edge ||= get_edge(west_edge.last, :east)
  end

  def grow_north_edge
    new_north_edge = []
    if north_edge.any? { |cell| cell.alive? }
      west_neighbor = nil
      southwest_neighbor = nil
      north_edge.each do |south_neighbor|
        new_cell = Cell.new
        new_north_edge << new_cell
        new_cell.attach(south_neighbor, :south)
        new_cell.attach(west_neighbor, :west) if west_neighbor
        new_cell.attach(southwest_neighbor, :southwest) if southwest_neighbor
        west_neighbor = new_cell
        southwest_neighbor = south_neighbor
      end
    end
    @north_edge = new_north_edge
    @first_cell = new_north_edge.first
  end

  def maybe_grow_field
    grow_north_edge
  end

  # TODO can only add if we are not playing yet, otherwise the indexes will get messed up
  def add(is_alive)
    raise 'too many cells' if ncells >= max
    cell = Cell.new(is_alive)
    i = ncells
    @cells << cell

    cell.attach(@cells[northeast_neighbor_index(i)], :northeast) if northeast_neighbor_index(i)
    cell.attach(@cells[north_neighbor_index(i)], :north) if north_neighbor_index(i)
    cell.attach(@cells[northwest_neighbor_index(i)], :northwest) if northwest_neighbor_index(i)
    cell.attach(@cells[west_neighbor_index(i)], :west) if west_neighbor_index(i)

    @first_cell = cell if @cells.size == 1
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
