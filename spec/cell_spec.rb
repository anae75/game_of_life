require 'spec_helper'
require_relative '../cell'

describe Cell do
  it 'can be created' do
  end

  it 'is dead when created' do
    cell = Cell.new
    expect(cell).not_to be_alive
  end

  it 'can be dead or alive' do
    cell = Cell.new
    cell.alive = true
    expect(cell).to be_alive

    cell.alive = false
    expect(cell).not_to be_alive
  end

  it 'can count live neighbors' do
    cell = Cell.new
    (cell.north = Cell.new).alive = true
    (cell.south = Cell.new).alive = true
    (cell.east  = Cell.new).alive = false
    (cell.southeast = Cell.new).alive = false
    expect(cell.live_neighbors).to be(2)
  end

  it 'can count dead neighbors' do
    cell = Cell.new
    (cell.north = Cell.new).alive = true
    (cell.south = Cell.new).alive = true
    (cell.east  = Cell.new).alive = false
    (cell.southeast = Cell.new).alive = false
    expect(cell.dead_neighbors).to be(2)
  end

  it 'should die if fewer than 2 live neighbors' do
    cell = create_cell_with_8_neighbors

    # no live neighbors
    cell.alive = true
    cell.tick
    expect(cell).not_to be_alive

    # 1 live neighbor
    cell.alive = true
    cell.south.alive = true
    cell.tick
    expect(cell).not_to be_alive

  end

  it 'should die if more than 3 live neighbors' do
    cell = create_cell_with_8_neighbors
    cell.alive = true
    cell.south.alive = true
    cell.west.alive = true
    cell.southwest.alive = true
    cell.southeast.alive = true
    cell.tick
    expect(cell).not_to be_alive
  end

  it 'should remain alive if 2 or 3 live neighbors' do
    cell = create_cell_with_8_neighbors

    # 2 live neighbors
    cell.alive = true
    cell.south.alive = true
    cell.west.alive = true
    cell.tick
    expect(cell).to be_alive

    # 3 live neighbors
    cell.alive = true
    cell.northwest.alive = true
    cell.tick
    expect(cell).to be_alive

  end


  it 'should become alive if exactly 3 live neighbors' do
    cell = create_cell_with_8_neighbors

    cell.alive = false
    cell.south.alive = true
    cell.west.alive = true
    cell.northwest.alive = true

    cell.tick
    expect(cell).to be_alive

  end

  def create_cell_with_8_neighbors
    cell = Cell.new
    Cell::NEIGHBORS.each do |name|
      cell.send("#{name}=", Cell.new)
    end
    cell
  end

end
