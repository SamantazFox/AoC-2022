INPUT = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end

class Point
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


def get(canvas, x, y) : PixelType
  point = canvas[coordinates_ify(x, y)]?
  return point if !point.nil?

  return PixelType::Wall if y == (MAX_Y+2)
  return PixelType::Air
end


# Draw!
def draw_map(canvas)
  s = String.build do |str|
    (MIN_Y..MAX_Y).each do |y|
      (MIN_X..MAX_X).each do |x|
        v = get(canvas, x, y)
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
end


def sand_fall_tick(p : Point, canvas)
  down = get(canvas, p.x, p.y+1)
  diag_L = get(canvas, p.x-1, p.y+1)
  diag_R = get(canvas, p.x+1, p.y+1)

  if down.air?
    p.y += 1
    return true
  elsif diag_L.air?
    p.x -= 1
    p.y += 1
    return true
  elsif diag_R.air?
    p.x += 1
    p.y += 1
    return true
  else
    return false
  end
end

work_canvas = CANVAS.dup

landed = 0

loop do
  point = Point.new(500, 0)

  while true
    # True = still falling / False = Stopped
    falling = sand_fall_tick(point, work_canvas)

    break if !falling
    break if point.y > MAX_Y
  end

  break if point.y > MAX_Y

  work_canvas[coordinates_ify(point.x, point.y)] = PixelType::Sand
  landed += 1
end


puts "Part 1:"
# draw_map(work_canvas)
pp landed



work_canvas_2 = CANVAS.dup

landed_2 = 0

loop do
  point = Point.new(500, 0)

  while true
    # True = still falling / False = Stopped
    falling = sand_fall_tick(point, work_canvas_2)
    break if !falling
  end

  coords = coordinates_ify(point.x, point.y)
  work_canvas_2[coords] = PixelType::Sand

  landed_2 += 1

  # Stop if sand source is blocked...
  break if get(work_canvas_2, 500, 0).sand?

  # if landed_2 % 1000 == 0
  #   print "\33c\e[3J"
  #   draw_map(work_canvas_2)
  # end
end


puts "\nPart 2:"
# draw_map(work_canvas_2)
pp landed_2
