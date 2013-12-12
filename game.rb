require_relative 'cell'

class Game
  attr_accessor :cells
  attr_accessor :dead_char, :live_char
  def initialize(rows = 3, cols = 3)
    @cells = []
    @nrows = rows
    @ncols = cols
    @dead_char = '.'
    @live_char = 'x'
  end

  def add_cells(*cells_to_add)
    @cells += cells_to_add
  end

  def tick
    maybe_grow_field
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
    row_start = @first_cell
    while row_start
      output_row_state(row_start)
      puts
      row_start = row_start.south
    end
  end

  def pprint_indexes
    row_start = @first_cell
    while row_start
      output_row(row_start)
      puts
      row_start = row_start.south
    end
  end

  def get_edge(cell, direction)
    tmp = []
    begin
      tmp << cell
      cell = cell.send(direction)
    end while cell
    tmp
  end

  def grow_edge(old_edge, opts)
    new_edge = []
    prev_new_cell = nil
    prev_edge_cell = nil
    next_edge_cell = nil

    old_edge.each_with_index do |edge_cell, i|
      new_cell = Cell.new
      @cells << new_cell
      new_edge << new_cell
      next_edge_cell = old_edge[i+1]
      new_cell.attach(edge_cell, opts[:edge_cell])
      new_cell.attach(prev_edge_cell, opts[:prev_edge_cell]) if prev_edge_cell
      new_cell.attach(next_edge_cell, opts[:next_edge_cell]) if next_edge_cell
      new_cell.attach(prev_new_cell, opts[:prev_new_cell]) if prev_new_cell
      prev_new_cell = new_cell
      prev_edge_cell = edge_cell
    end

    new_edge
  end

  def reset_edges
    @north_edge = @south_edge = @west_edge = @east_edge = nil
  end

  def north_edge
    @north_edge ||= get_edge(@first_cell, :east)
  end

  def grow_north_edge
    @north_edge = grow_edge(north_edge,
      edge_cell: :south,
      prev_edge_cell: :southwest,
      next_edge_cell: :southeast,
      prev_new_cell: :west
    )
    @first_cell = @north_edge.first
    reset_edges
  end

  def west_edge
    @west_edge ||= get_edge(@first_cell, :south)
  end

  def grow_west_edge
    @west_edge = grow_edge(west_edge,
      edge_cell: :east,
      prev_edge_cell: :northeast,
      next_edge_cell: :southeast,
      prev_new_cell: :north
    )
    @first_cell = @west_edge.first
    reset_edges
  end

  def east_edge
    @east_edge ||= get_edge(north_edge.last, :south)
  end

  def grow_east_edge
    @east_edge = grow_edge(east_edge,
      edge_cell: :west,
      prev_edge_cell: :northwest,
      next_edge_cell: :southwest,
      prev_new_cell: :north
    )
    reset_edges
  end

  def south_edge
    @south_edge ||= get_edge(west_edge.last, :east)
  end

  def grow_south_edge
    @south_edge = grow_edge(south_edge,
      edge_cell: :north,
      prev_edge_cell: :northwest,
      next_edge_cell: :northeast,
      prev_new_cell: :west
    )
    reset_edges
  end

  def maybe_grow_field
    grow_north_edge if north_edge.any? { |cell| cell.alive? }
    grow_south_edge if south_edge.any? { |cell| cell.alive? }
    grow_east_edge if east_edge.any? { |cell| cell.alive? }
    grow_west_edge if west_edge.any? { |cell| cell.alive? }
  end

  def output_row(cell)
    while cell
      print " %5d " % cell.id
      cell = cell.east
    end
  end

  def output_row_state(cell)
    while cell
      print cell.alive? ? live_char : dead_char
      cell = cell.east
    end
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
