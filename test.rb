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

end.parse!

@games = {}
def game(name)
  @games[name] = yield
end

game 'spaceship' do
  board =<<-END
  001000
  000100
  011100
  000000
  000000
  END
end

game 'pulsar1' do
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

game 'pulsar2' do
board =<<-END
  0010000100
  1101111011
  0010000100
END
end

game 'broken_glider' do
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

game 'acorn' do
board =<<-END
  0100000
  0001000
  1100111
END
end

game 'toad' do
board =<<-END
  0111
  1110
END
end

game 'beacon' do
board =<<-END
  1100
  1100
  0011
  0011
END
end

game 'diehard' do
board =<<-END
  00000000
  00000010
  11000000
  01000111
END
end

game 'glider_gun' do
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

def play(name, options)
  clear_code = %x(clear)

  game = game_from(@games[name])
  game.dead_char = ' '

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
