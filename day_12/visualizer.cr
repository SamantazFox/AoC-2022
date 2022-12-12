require "colorize"

input = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end


level_map = input.split('\n', remove_empty: true).map &.chars

# https://colordesigner.io/gradient-generator
# Start : HSV = 203 / 85 / 85
# End   : HSV =  0  / 85 / 85
gradient = {
  'a' => Colorize::ColorRGB.new(33, 147, 217),
  'b' => Colorize::ColorRGB.new(50, 144, 219),
  'c' => Colorize::ColorRGB.new(65, 141, 220),
  'd' => Colorize::ColorRGB.new(79, 137, 221),
  'e' => Colorize::ColorRGB.new(93, 133, 221),
  'f' => Colorize::ColorRGB.new(106, 129, 220),
  'g' => Colorize::ColorRGB.new(119, 124, 218),
  'h' => Colorize::ColorRGB.new(131, 119, 215),
  'i' => Colorize::ColorRGB.new(143, 114, 211),
  'j' => Colorize::ColorRGB.new(154, 108, 206),
  'k' => Colorize::ColorRGB.new(165, 102, 200),
  'l' => Colorize::ColorRGB.new(175, 95, 194),
  'm' => Colorize::ColorRGB.new(184, 88, 186),
  'n' => Colorize::ColorRGB.new(193, 81, 178),
  'o' => Colorize::ColorRGB.new(200, 73, 168),
  'p' => Colorize::ColorRGB.new(207, 65, 158),
  'q' => Colorize::ColorRGB.new(213, 56, 147),
  'r' => Colorize::ColorRGB.new(218, 47, 136),
  's' => Colorize::ColorRGB.new(221, 39, 124),
  't' => Colorize::ColorRGB.new(224, 30, 112),
  'u' => Colorize::ColorRGB.new(225, 22, 100),
  'v' => Colorize::ColorRGB.new(226, 16, 87),
  'w' => Colorize::ColorRGB.new(225, 14, 74),
  'x' => Colorize::ColorRGB.new(223, 17, 61),
  'y' => Colorize::ColorRGB.new(220, 24, 47),
  'z' => Colorize::ColorRGB.new(216, 32, 32),
}


str = level_map.map do |line|
  line.map do |char|
    if char == 'S'
      char.colorize(gradient['a']).bold
    elsif char == 'E'
      char.colorize(gradient['z']).bold
    else
      char.colorize(gradient[char])
    end
  end.join("")
end.join('\n')

puts str
