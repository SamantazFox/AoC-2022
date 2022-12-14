INPUT = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end

struct Point
  property x : Int32
  property y : Int32

  def initialize(@x, @y)
  end
end

struct Shape
  property vertices = [] of Point

  def initialize(@vertices)
  end
end

def coordinates_ify(x, y)
  return "#{x}/#{y}"
end


SHAPES = INPUT.split('\n', remove_empty: true).map do |line|
  points = line.split(" -> ").map do |coord|
    x, y = coord.split(',')
    Point.new(x.to_i, y.to_i)
  end

  Shape.new(points)
end


enum PixelType
  Air
  Wall
  Sand
end

def draw_shapes
  canvas = {} of String => PixelType

  SHAPES.each do |shape|
    (shape.vertices.size - 1).times do |i|
      p1 = shape.vertices[i]
      p2 = shape.vertices[i+1]

      if (p2.x - p1.x) == 0
        # Draw a vertical line
        y_start, y_end = [p1.y, p2.y].sort
        (y_start..y_end).each do |y|
          canvas[coordinates_ify(p1.x, y)] = PixelType::Wall
        end
      elsif (p2.y - p1.y) == 0
        # Draw an horizontal line
        x_start, x_end = [p1.x, p2.x].sort
        (x_start..x_end).each do |x|
          canvas[coordinates_ify(x, p1.y)] = PixelType::Wall
        end
      else
        raise Exception.new "Diagonals not supported"
      end
    end
  end

  return canvas
end

CANVAS = draw_shapes

ALL_VERT = SHAPES.map(&.vertices).sum

ALL_X = ALL_VERT.map(&.x)
MIN_X = ALL_X.min
MAX_X = ALL_X.max

ALL_Y = ALL_VERT.map(&.y)
MIN_Y = ALL_Y.min
MAX_Y = ALL_Y.max


# Draw!
s = String.build do |str|
  (MIN_Y..MAX_Y).each do |y|
    (MIN_X..MAX_X).each do |x|
      v = CANVAS[coordinates_ify(x, y)]? || PixelType::Air
      case v
      when .wall? then str << '#'
      when .sand? then str << 'O'
      else
        str << '.'
      end
    end

    str << '\n'
  end
end

puts s
