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

# a glider
def setup_5
board =<<-END
001000
000100
011100
000000
000000
END
end

# a pulsar
def setup_6
board =<<-END
  0011100011100
  0000000000000
  1000010100001
  1000010100001
  1000010100001
  0011100011100
  0000000000000
  0011100011100
  1000010100001
  1000010100001
  1000010100001
  0000000000000
  0011100011100
END
end

# a pulsar
def setup_7
board =<<-END
  0010000100
  1101111011
  0010000100
END
end

# should be a glider (broken)
def setup_8
board =<<-END
  0000001
  0000010
  0000100
  0001000
  0010000
  0000000
  1000000
  1001000
  1010000
  0000000
  0010000
END
end

# acorn
def setup_9
board =<<-END
  0100000
  0001000
  1100111
END
end

# pulsar (toad)
def setup_9
board =<<-END
  0111
  1110
END
end

# pulsar (beacon)
def setup_10
board =<<-END
  1100
  1100
  0011
  0011
END
end

# glider gun
def setup_glider_gun
board =<<-END
0000000000000000000000001000000000000000
0000000000000000000000101000000000000000
0000000000001100000011000000000000110000
0000000000010001000011000000000000110000
1100000000100000100011000000000000000000
1100000000100010110000101000000000000000
0000000000100000100000001000000000000000
0000000000010001000000000000000000000000
0000000000001100000000000000000000000000
END
end

clear_code = %x(clear)

game = game_from(setup_glider_gun)
game.dead_char = ' '

prompt = false

60.times do |i|
  print clear_code
#  puts

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

  if prompt
    input = STDIN.gets.strip
    case input
      when "b"
        break
      when "p"
        binding.pry
    end
  else
    sleep(0.5)
  end

  game.tick
end
