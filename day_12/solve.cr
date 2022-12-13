require "colorize"

INPUT = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end

RAW_MAP = INPUT.split('\n', remove_empty: true).map(&.chars)


def coordinates_ify(x, y)
  return "#{x}/#{y}"
end

enum Direction
  Up
  Down
  Left
  Right
end


class Map
  class_getter points = {} of String => Point
end


def show_map
  str = RAW_MAP.map_with_index do |line, y|
    line.map_with_index do |char, x|
      point = Map.points[coordinates_ify(x, y)]

      if point.visited
        String.new(Slice.new(1, (point.elevation + 'a'.ord).to_u8)).colorize(:white)
      else
        String.new(Slice.new(1, (point.elevation + 'a'.ord).to_u8)).colorize(:dark_gray)
      end
    end.join("")
  end.join('\n')

  print "\33c\e[3J"
  puts str
end

class Point
  property x : Int32
  property y : Int32

  property elevation : Int32

  property visited = false
  property tentative_dist : Int32 = 999_999_999

  def initialize(@x, @y, elev : Char)
    @elevation = elev.ord - 'a'.ord
    Map.points[coordinates_ify(@x, @y)] = self
  end

  def reset
    @visited = false
    @tentative_dist = 999_999_999
  end

  # neighbors

  def nb(dir : Direction) : Point?
    case dir
    when .up?    then return Map.points[coordinates_ify(@x, @y-1)]?
    when .down?  then return Map.points[coordinates_ify(@x, @y+1)]?
    when .left?  then return Map.points[coordinates_ify(@x-1, @y)]?
    when .right? then return Map.points[coordinates_ify(@x+1, @y)]?
    end
  end

  #def has_step_nb
  #  return true if (nb_up.try &.elevation) == (@elevation + 1)
  #  return true if (nb_down.try &.elevation) == (@elevation + 1)
  #  return true if (nb_left.try &.elevation) == (@elevation + 1)
  #  return true if (nb_right.try &.elevation) == (@elevation + 1)
  #  return false
  #end

  def explore
    # puts "Exploring #{@x}, #{@y}"
    # show_map

    # Stop here if self is the destination
    return if coordinates_ify(@x, @y) == BEST

    Direction.each do |dir|
      nb = self.nb(dir)
      next if nb.nil?

      # Avoid unreachable cells and "holes" at the beginning of the map
      reachable = @elevation >= (nb.elevation-1)
      nb_is_hole = (@elevation == 2 && nb.elevation == 0)
      next if !reachable || nb_is_hole

      if !nb.visited
        nb.visited = true
        nb.tentative_dist = @tentative_dist + 1
        #puts " -- nb #{dir} / #{nb.visited} / #{nb.tentative_dist}"

        nb.explore
      else
        new_dist = @tentative_dist + 1
        if new_dist < nb.tentative_dist
          nb.tentative_dist = new_dist
          nb.explore
        end
        #puts " -- nb #{dir} / #{nb.tentative_dist}"
      end
    end
  end    
end

START = "0/20"
BEST = "148/20"


RAW_MAP.each_with_index do |line, y|
  line.each_with_index do |char, x|
    coords = coordinates_ify(x, y)

    if char == 'S'
      # START = coords
      Point.new(x, y, 'a')
      puts "Start point at #{coords}"
    elsif char == 'E'
      # BEST = coords
      Point.new(x, y, 'z')
      puts "Dest point at #{coords}"
    else
      Point.new(x, y, char)
    end
  end
end

Map.points[START].tentative_dist = 0
Map.points[START].explore

puts "Part 1:"
pp Map.points[BEST].tentative_dist


part2_paths = [] of Int32

{0, 2, 3}.each do |x|
  (0..40).each do |y|
    coords = coordinates_ify(0, y)
    point = Map.points[coords]

    next if point.elevation != 0

    Map.points.each_value(&.reset)
    point.tentative_dist = 0
    point.explore

    puts "#{coords} = #{Map.points[BEST].tentative_dist}"
    part2_paths << Map.points[BEST].tentative_dist
  end
end


puts "\nPart 2:"
pp part2_paths
pp part2_paths.min
