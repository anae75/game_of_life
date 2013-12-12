class Cell
  @@id = 0
  def self.next_id
    id = @@id
    @@id += 1
    id
  end

  attr_accessor :alive, :id
  alias :alive? :alive

  attr_accessor :changed

  NEIGHBORS = [:north, :south, :west, :east, :northwest, :northeast, :southwest, :southeast]
  attr_accessor *NEIGHBORS
  INVERSE = {
    :north => :south,
    :south => :north,
    :west => :east,
    :east => :west,
    :northwest => :southeast,
    :southeast=> :northwest,
    :northeast => :southwest,
    :southwest =>:northeast
  }

  def initialize(is_alive = false)
    @id = Cell.next_id
    @alive = is_alive
  end

  def live_neighbors
    NEIGHBORS.inject(0) do |memo, name|
      cell = self.send(name)
      memo += 1 if cell && cell.alive?
      memo
    end
  end

  def dead_neighbors
    NEIGHBORS.inject(0) do |memo, name|
      cell = self.send(name)
      memo += 1 if cell && !cell.alive?
      memo
    end
  end

  def decide
    @newval = @alive
    if @alive
      @newval = false if (live_neighbors < 2 || live_neighbors > 3)
    else
      @newval = true if (live_neighbors == 3)
    end
  end

  def apply
    @changed = (@alive == @newval)
    @alive = @newval
  end

  def tick
    decide
    apply
  end

  def detach(direction)
    cell = self.send(direction)
    return if !cell             # already nil, nothing to be done
    self.send("#{direction}=", nil)
    cell.detach(INVERSE[direction])
  end

  def attach(cell, direction)
    return if self.send(direction) == cell      # already true, nothing to be done
    detach(direction)
    self.send("#{direction}=", cell)
    cell.attach(self, INVERSE[direction])
  end

  def to_s
    "(cell #{@id})"
  end

end
