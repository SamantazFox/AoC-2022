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

# init known visible trees
#grid[0].each(&.visible_v = true)
#grid[-1].each(&.visible_v = true)
#grid.each do |row|
#  row[0].visible_h = true
#  row[-1].visible_h = true
#end

def print_map #(focus_y)
  # Magic!
  print "\33c\e[3J"

  s = String.build do |str|
    GRID.each_with_index do |row, y|
      break if y > 10
    
      row.each do |tree|
        if tree.visible?
          str << "1".colorize(:blue)
        else
          str << "0".colorize(:dark_gray)
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
  GRID.each_with_index do |row, y|
    break if y > 10
  
    row.each_with_index do |tree, x|
      if y == 0
        tree.visible_v = true 
        # print_map
        next
      end

      previous_tree = GRID[y-1][x]
      tree.visible_v = previous_tree.visible_v && (tree.size > previous_tree.size)
      # print_map
    end
  end

  GRID.reverse!
end


# Left/Right then Right/Left
GRID.each_with_index do |row, y|
  2.times do |i|
    row.each_with_index do |tree, x|
      next if x > 10

      if x == 0
        tree.visible_h = true 
        # print_map
        next
      end

      previous_tree = GRID[y][x-1]
      tree.visible_h = previous_tree.visible_h && (tree.size > previous_tree.size)
      # print_map
    end

    row.reverse!
  end
end

visible = 0
GRID.each &.each { |tree| visible += 1 if tree.visible? }


puts "Part 1:"
pp visible
