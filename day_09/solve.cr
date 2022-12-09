input = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end


struct Move
  property direction : String
  property count : Int32

  def initialize(@direction, @count)
  end
end

moves = input.split('\n', remove_empty: true).map do |line|
  dir, count = line.split(" ")
  Move.new(dir, count.to_i)
end


class Point
  property x : Int32 = 100
  property y : Int32 = 100

  def move(follow : Point)
    x_diff = follow.x - self.x
    y_diff = follow.y - self.y

    x_off = 0
    y_off = 0

    if x_diff == 0 && y_diff.abs == 2
      # Other point is now 2 places away vertically
      y_off = y_diff // 2
      
    elsif y_diff == 0 && x_diff.abs == 2
      # Other point is now 2 places away horizontally
      x_off = x_diff // 2

    elsif x_diff.abs == 2 || y_diff.abs == 2
      # Other point is one or two places away diagonally
      x_off = x_diff.sign
      y_off = y_diff.sign
    end

    #pp self.inspect
    #pp follow.inspect
    #puts "x/y diff #{x_diff}/#{y_diff}"

    self.x += x_off
    self.y += y_off

    # puts "Head moves #{dir}! Head is now at #{HEAD.x} / #{HEAD.y}"
    # puts "Tail moves #{tail_dir}, now at #{TAIL.x} / #{TAIL.y}"
    # print_map
  end
end


HEAD = Point.new
TAIL = Point.new

visited = {} of String => Bool


def print_map
  # Magic!
  # print "\33c\e[3J"

  s = String.build do |str|
    (80..120).each do |y|
      (70..130).each do |x|
        if x == HEAD.x && y == HEAD.y
          str << 'H'
        elsif x == TAIL.x && y == TAIL.y
          str << 'T'
        elsif x == 100 && y == 100
          str << 's'
        else
          str << '.'
        end
      end

      str << '\n'
    end
  end

  print s
  sleep 1.second
end



moves.each do |move|
  move.count.times do |i|
    dir = move.direction

    case dir
    when "U" then HEAD.y -= 1
    when "D" then HEAD.y += 1
    when "L" then HEAD.x -= 1
    when "R" then HEAD.x += 1
    else
      # Uh Oh...
      raise Exception.new "Unsupported move!!!"
    end

    TAIL.move(follow: HEAD)

    visited["#{TAIL.x}/#{TAIL.y}"] = true
  end
end


puts "Part 1:"
pp visited.size



POINTS = (0..9).map { |_| Point.new }
visited_2 = {} of String => Bool

def print_map_2
  s = String.build do |str|
    (80..120).each do |y|
      (70..130).each do |x|
        {% begin %}
          if x == POINTS[0].x && y == POINTS[0].y
            str << 'H'
          {% for x in 1..9 %}
            elsif x == POINTS[{{x}}].x && y == POINTS[{{x}}].y
              str << {{x.stringify}}
          {% end %}
          elsif x == 100 && y == 100
            str << 's'
          else
            str << '.'
          end
        {% end %}
      end

      str << '\n'
    end
  end

  print s
  sleep 30.milliseconds
end


moves.each do |move|
  move.count.times do |_|
    case move.direction
    when "U" then POINTS[0].y -= 1
    when "D" then POINTS[0].y += 1
    when "L" then POINTS[0].x -= 1
    when "R" then POINTS[0].x += 1
    else
      # Uh Oh...
      raise Exception.new "Unsupported move!!!"
    end

    (1..9).each do |i|
      begin
        # Magic!
        #print "\33c\e[3J"

        POINTS[i].move(follow: POINTS[i-1])
        #print_map_2
      rescue ex
        raise Exception.new "Lost point #{i}", ex
      end
    end

    visited_2["#{POINTS[9].x}/#{POINTS[9].y}"] = true
  end

  # puts "\n\n\n\n== #{move.direction} #{move.count} ==\n"
  # print_map_2
end


puts "\nPart 2:"
pp visited_2.size
