require_relative 'game'
require 'pry'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: test.rb [options]"
  opts.on("-g name", "--game name", "which game to run") do |name|
    options[:game] = name
  end
  opts.on("-l", "--list", "list available games") do
    options[:list] = true
  end
  opts.on("-s name", "--show name", "show setup for name") do |name|
    options[:show] = name
  end
  opts.on("-p", "--prompt", "prompt in between iterations") do |arg|
    options[:prompt] = true
  end
  opts.on("-i n", "--iterations n", "number of iterations") do |arg|
  options[:iterations] = arg.to_i
  end
  opts.on("-d secs", "--delay secs", "seconds to delay") do |arg|
    options[:delay] = arg.to_f
  end
  opts.on("-C", "--no-clear", "don't clear the screen in between") do |arg|
    options[:clear] = false
  end
  opts.on("-c char", "--char char", "space char") do |arg|
    options[:char] = arg
  end

  opts.on("-m", "--manual", "read board from stdin") do |arg|
    options[:stdin] = true
  end

end.parse!

@games = {}
def game(name)
  @games[name] = yield
end

game 'spaceship' do
  board =<<-END
  ..1...
  ...1..
  .111..
  ......
  ......
  END
end

game 'pulsar1' do
board =<<-END
  ..111...111..
  .............
  1....1.1....1
  1....1.1....1
  1....1.1....1
  ..111...111..
  .............
  ..111...111..
  1....1.1....1
  1....1.1....1
  1....1.1....1
  .............
  ..111...111..
END
end

game 'pulsar2' do
board =<<-END
  ..1....1..
  11.1111.11
  ..1....1..
END
end

game 'broken_glider' do
board =<<-END
  ......1
  .....1.
  ....1..
  ...1...
  ..1....
  .......
  1......
  1..1...
  1.1....
  .......
  ..1....
END
end

game 'acorn' do
board =<<-END
  .1.....
  ...1...
  11..111
END
end

game 'toad' do
board =<<-END
  .111
  111.
END
end

game 'beacon' do
board =<<-END
  11..
  11..
  ..11
  ..11
END
end

game 'diehard' do
board =<<-END
  ........
  ......1.
  11......
  .1...111
END
end

game 'glider_gun' do
board =<<-END
........................1...............
......................1.1...............
............11......11............11....
...........1...1....11............11....
11........1.....1...11..................
11........1...1.11....1.1...............
..........1.....1.......1...............
...........1...1........................
............11..........................
END
end

game 'block_layer_1' do
board =<<-END
......1..
....1.11.
....1.1..
....1....
..1......
1.1......
END
end

game 'block_layer_2' do
board =<<-END
111.1
1....
...11
.11.1
1.1.1
END
end

game 'bar' do
<<-END
1
1
1
END
end

game 'cross' do
<<-END
.1.
111
.1.
END
end

game '4_brick_layer' do
<<-END
1111.
1111.
..111
..111
..111
END
end

game '4_brick_layer_2' do
<<-END
111.1
.....
1111.
..11.
1111.
END
end

game 'circle_cross' do
<<-END
1..11
1.1.1
....1
..1.1
1.11.
END
end

game 'sir_growsalot' do
<<-END
.....
.1111
11.11
.1111
11...
END
end

game 'fires_a_spaceship' do
<<-END
11.1.1
1.1..1
1111.1
....11
.111.1
111...
END
end

game 'fires_a_spaceship_2' do
<<-END
..11..
1...11
.1.111
1....1
....11
.1.1.1
END
end

game 'big_o_little_o' do
<<-END
.11...
11111.
1.1111
..111.
11....
.1.111
END
end

game 'shoot_rings' do
<<-END
..1.......
...1......
.111......
..........
..........
..........
..........
..........
.....11...
....11111.
....1.1111
......111.
....11....
.....1.111
END
end

game 'shoot_rings_2' do
<<-END
..1...........
...1..........
.111..........
..............
..............
..............
..............
..............
..............
..............
..............
..............
.........11...
........11111.
........1.1111
..........111.
........11....
.........1.111
END
end

game 'shoot_rings_3' do
<<-END
..1...................
...1..................
.111..................
......................
......................
......................
......................
......................
......................
......................
......................
......................
.................11...
................11111.
................1.1111
..................111.
................11....
.................1.111
END
end

game 'shoot_rings_4' do
<<-END
..1.......................
...1......................
.111......................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
..........................
.....................11...
....................11111.
....................1.1111
......................111.
....................11....
.....................1.111
END
end

game 'lay_bricks' do
<<-END
1.11.1
....1.
..1...
.1.1..
.11.1.
......
END
end

game 'mirror_cloud' do
<<-END
11....
.1.1..
..111.
1.1.1.
.11...
.....1
END
end

game 'four_ring_clover' do
<<-END
1..11.
11....
1111.1
..11.1
1.111.
.11...
END
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

def randchar
  rand(10) > 4 ? '1' : '.'
end
def random(rows = 6, cols = 6)
  srand
  str = ''
  rows.times do
    cols.times do
      str << randchar
    end
    str << "\n"
  end
  str
end

game 'random' do
  random
end

def play(name, options)
  clear_code = %x(clear)

  unless @games[name]
    puts "Can't find game #{name}"
    puts @games.keys.sort
    exit
  end

  game = game_from(@games[name])
  char = options[:char] || ' '
  game.dead_char = char

  prompt = options[:prompt] || false
  iterations = options[:iterations] || 50
  delay = options[:delay] || 0.5
  clear = options.has_key?(:clear) ? options[:clear] : true

  iterations.times do |i|
    clear ? print( clear_code ) : puts

    game.pprint
    if game.nliving.zero?
      puts "nothing left alive #{i}"
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
      sleep(delay)
    end

    game.tick
  end

  if name == 'random'
    puts @games['random']
  end
end

if options[:list]
  puts @games.keys.sort
  exit
end

if options[:show]
  name = options[:show]
  puts @games[name]
  exit
end

if name = options[:game]
  play(name, options)
end

if options[:stdin]
  str = STDIN.read
  @games['stdin'] = str
  play('stdin', options)
end

