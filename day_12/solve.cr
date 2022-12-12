require "colorize"

input = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end

RAW_MAP = input.split('\n', remove_empty: true).map(&.chars)


def coordinates_ify(x, y)
  return "#{x}/#{y}"
end


class Point
  property x : Int32
  property y : Int32

  property elevation : Int32

  def initialize(@x, @y, elev : Char)
    @elevation = elev.ord - 'a'.ord
  end

  # neighbors

  def nb_up : Point?
    return LEVEL_MAP[coordinates_ify(@x, @y-1)]?
  end

  def nb_down : Point?
    return LEVEL_MAP[coordinates_ify(@x, @y+1)]?
  end

  def nb_left : Point?
    return LEVEL_MAP[coordinates_ify(@x-1, @y)]?
  end

  def nb_right : Point?
    return LEVEL_MAP[coordinates_ify(@x+1, @y)]?
  end

  # neighbor finder

  def has_step_nb
    return true if (nb_up.try &.elevation) == (@elevation + 1)
    return true if (nb_down.try &.elevation) == (@elevation + 1)
    return true if (nb_left.try &.elevation) == (@elevation + 1)
    return true if (nb_right.try &.elevation) == (@elevation + 1)
    return false
  end
end

start = nil
best = nil


def parse_points
  level_map = {} of Point

  RAW_MAP.each_with_index do |line, y|
    line.each_with_index do |char, x|
      coords = coordinates_ify(x, y)
  
      if char == 'S'
        start = Point.new(x, y, 'a')
        level_map[coords] << start
      elsif char == 'E'
        best = Point.new(x, y, 'z')
        level_map[coords] << best
      else
        level_map[coords] << Point.new(x, y, char)
      end
    end
  end

  return level_map
end

LEVEL_MAP = parse_points()


def find_step_candidates(elev : Int)
  step = elev + 1
    
  return LEVEL_MAP
    .find(&.elevation.== step)
    .select(&.has_step_nb)
end
