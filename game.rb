class Game
  def initialize
    @cells = []
  end

  def add_cells(*cells_to_add)
    @cells += cells_to_add
  end

  def tick
    @cells.each { |cell| cell.decide }
    @cells.each { |cell| cell.apply }
  end
end
