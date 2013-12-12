require 'spec_helper'
require_relative '../game.rb'
require_relative '../cell.rb'
require 'pry'

describe Game do
  it 'can be created' do
    game = Game.new
    expect(game).to be_true
  end

  example do
    a = Cell.new(true)
    b = Cell.new(true)
    c = Cell.new(true)
    a.east = b
    b.west = a
    b.east = c
    c.west = b
    game = Game.new
    game.add_cells a, b, c
    game.tick

    expect(a).not_to be_alive
    expect(b).to be_alive
    expect(c).not_to be_alive
  end

  it 'can add cells' do
    game = Game.new

    game.add(true)

    expect(game.ncells).to be(1)
  end

  it 'attaches neighbors automatically' do
    game = Game.new(2,2)

    game.add(true)
    game.add(false)
    game.add(false)
    game.add(true)

    expect(game.cells[0].east).to be(game.cells[1])
    expect(game.cells[0].south).to be(game.cells[2])
    expect(game.cells[0].southeast).to be(game.cells[3])
  end

  it 'raises an error if too many cells are added' do
    game = Game.new(2,1)
    game.add(true)
    game.add(false)

    expect {
      game.add(true)
    }.to raise_error

  end

  it 'correctly calculates indexes for neighbors' do
    game = Game.new(3,3)

    test_data = [
      [0, nil, nil, nil, nil],
      [1, nil, nil, nil, 0  ],
      [2, nil, nil, nil, 1  ],
      [3, 1,   0  , nil, nil],
      [4, 2,   1  , 0,   3  ],
      [5, nil, 2  , 1,   4  ],
      [6, 4,   3  , nil, nil],
      [7, 5,   4  , 3,   6  ],
      [8, nil, 5  , 4,   7  ]
    ]

    test_data.each do |i, ne, n, nw, w|
      expect(game.northeast_neighbor_index(i)).to be(ne)
      expect(game.north_neighbor_index(i)).to be(n)
      expect(game.northwest_neighbor_index(i)).to be(nw)
      expect(game.west_neighbor_index(i)).to be(w)
    end


  end
end
