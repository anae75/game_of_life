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
end
