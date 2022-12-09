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

    # print "\33c\e[3J"

    case dir
    when "U" then HEAD.y -= 1
    when "D" then HEAD.y += 1
    when "L" then HEAD.x -= 1
    when "R" then HEAD.x += 1
    else
      # Uh Oh...
      raise Exception.new "Unsupported move!!!"
    end

    x_diff = HEAD.x - TAIL.x
    y_diff = HEAD.y - TAIL.y

    x_off = 0
    y_off = 0

    tail_dir = "0"

    if x_diff == 0 && y_diff.abs == 2
      # Head is now 2 places away vertically
      y_off = y_diff // 2
      tail_dir = y_diff > 0 ? "D" : "U"
      
    elsif y_diff == 0 && x_diff.abs == 2
      # Head is now 2 places away horizontally
      x_off = x_diff // 2
      tail_dir = x_diff > 0 ? "R" : "L"

    elsif x_diff.abs == 1 && y_diff.abs == 2
      # Head is one place away horizontally and two vertically
      x_off = x_diff
      y_off = y_diff // 2
      tail_dir = "V"

    elsif y_diff.abs == 1 && x_diff.abs == 2
      # Head is one place away vertically and two horizontally
      x_off = x_diff // 2
      y_off = y_diff
      tail_dir = "H"

    elsif x_diff.abs <= 1 && y_diff.abs <= 1
      # The two points overlap, or are in the same 9x9 chunk
      # (centered around HEAD) so do nothing

    else
      # Uh Oh...
      raise Exception.new "We lost the tail! (#{TAIL.x} / #{TAIL.y})"
    end

    TAIL.x += x_off
    TAIL.y += y_off

    visited["#{TAIL.x}/#{TAIL.y}"] = true

    # puts "Head moves #{dir}! Head is now at #{HEAD.x} / #{HEAD.y}"
    # puts "Tail moves #{tail_dir}, now at #{TAIL.x} / #{TAIL.y}"
    # print_map
  end
end


puts "Part 1:"
pp visited.size
