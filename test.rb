require_relative 'game'
require 'pry'

def setup_1
  game = Game.new(4,4)
  [true, false, false, true].each { |x| game.add x }
  [true, true, false, true].each { |x| game.add x }
  [false, true, true, true].each { |x| game.add x }
  game
end


def setup_2
  game = Game.new(5,5)
  [true, false, false, true, true ].each { |x| game.add x }
  [true, true, false, false, true].each { |x| game.add x }
  [false, true, true, true, true].each { |x| game.add x }
  game
end


def setup_3
  game = Game.new(4,4)
  [false, false, false, false].each { |x| game.add x }
  [false, true,  true, false].each { |x| game.add x }
  [false, true,  true, false].each { |x| game.add x }
  [false, false, false, false].each { |x| game.add x }
  game
end

def setup_4
  game = Game.new(5,5)
  [false, false, false, false, false].each { |x| game.add x }
  [false, false, true,  false, false].each { |x| game.add x }
  [false, false, true,  false, false].each { |x| game.add x }
  [false, false, true,  false, false].each { |x| game.add x }
  [false, false, false, false, false].each { |x| game.add x }
  game
end

def game_from(str)
  rows = str.split(/\n/).collect {|r| r.strip.split // }
  nrows = rows.size
  ncols = rows.inject(0) { |max, r| max = r.size if max < r.size; max }
  game = Game.new(nrows, ncols)
  rows.each do |row|
    row.each do |cell|
      game.add cell == '1'
    end
  end
  game
end

def setup_5
board =<<-END
001000
000100
011100
000000
000000
END
end

clear_code = %x(clear)

#game = setup_1
#game = setup_2
#game = setup_3
#game = setup_4
game = game_from(setup_5)

15.times do |i|
#  print clear_code
  puts

  game.pprint
  if game.nliving.zero?
    puts "nothing left alive"
    break
  end
  if game.steady_state
    puts "steady state"
    break
  end
  puts i
  sleep(2)
  game.tick
end
