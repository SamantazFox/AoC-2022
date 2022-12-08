require "colorize"

INPUT = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end

class Tree
  property size : Int32
  property visible_v = false
  property visible_h = false

  # view distances
  property vd_up = 0
  property vd_down = 0
  property vd_left = 0
  property vd_right = 0

  def initialize(@size)
  end

  def visible?
    @visible_v || @visible_h
  end

  def scenic_distance
    @vd_up * @vd_down * @vd_left * @vd_right
  end
end

GRID = INPUT.split('\n', remove_empty: true).map(&.split("").map { |n| Tree.new(n.to_i) })


def print_map
  # Magic!
  print "\33c\e[3J"

  s = String.build do |str|
    GRID.each_with_index do |row, y|
      row.each do |tree|
        if tree.visible_v && tree.visible_h
          str << tree.size.colorize(:light_green)
        elsif tree.visible_v
          str << tree.size.colorize(:light_red)
        elsif tree.visible_h
          str << tree.size.colorize(:light_blue)
        else
          str << tree.size.colorize(:dark_gray)
        end
      end

      str << '\n'
    end
  end

  puts s
  sleep 10.milliseconds
end


# Up/Down then Down/Up
2.times do |i|
  current_largest = GRID[0].map { |_| -1 }

  GRID.each_with_index do |row, y|
    row.each_with_index do |tree, x|
      if tree.size > current_largest[x]
        current_largest[x] = tree.size
        tree.visible_v = true
      end
    end
  end

  GRID.reverse!
end


# Left/Right then Right/Left
GRID.each_with_index do |row, y|
  2.times do |i|
    current_largest = -1

    row.each_with_index do |tree, x|
      if tree.size > current_largest
        tree.visible_h = true

        # there won't be any larger trees now
        break if tree.size == 9

        current_largest = tree.size
      end
    end

    row.reverse!
  end
end

print_map

visible = 0
GRID.each &.each { |tree| visible += 1 if tree.visible? }


puts "Part 1:"
pp visible



scenic_distances = [] of Int32

GRID.each_with_index do |row, y|
  row.each_with_index do |tree, x|
    # next if tree.size < 9 || !tree.visible_v || !tree.visible_h
  
    if y > 0
      # Look up
      (0...y).to_a.reverse.each do |other_y|
        tree.vd_up += 1
        break if GRID[other_y][x].size >= tree.size
      end
    end

    if y < GRID.size - 1
      # Look down
      ((y+1)...GRID.size).each do |other_y|
        tree.vd_down += 1
        break if GRID[other_y][x].size >= tree.size
      end
    end

    if x > 0
      # Look left
      (0...x).to_a.reverse.each do |other_x|
        tree.vd_left += 1
        break if GRID[y][other_x].size >= tree.size
      end
    end

    if x < row.size - 1
      # Look right
      ((x+1)...row.size).each do |other_x|
        tree.vd_right += 1
        break if GRID[y][other_x].size >= tree.size
      end
    end

    #puts "Tree at #{x},#{y}: #{tree.vd_up} / #{tree.vd_down} / #{tree.vd_left} / #{tree.vd_right}"
    scenic_distances << tree.scenic_distance
  end
end


puts "\nPart 2:"
pp scenic_distances.max
