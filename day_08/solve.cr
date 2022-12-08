require "colorize"

INPUT = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end

class Tree
  property size : Int32
  property visible_v = false
  property visible_h = false

  def initialize(@size)
  end

  def visible?
    @visible_v || @visible_h
  end
end

GRID = INPUT.split('\n', remove_empty: true).map(&.split("").map { |n| Tree.new(n.to_i) })


def print_map #(focus_y)
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
