input = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end

reg_x = 1
cycle = 0
reg_states = [1] # Init with cycle 0

pixels = [] of Char


def draw_pixel(cycle, reg_x)
  if ((reg_x-1)..(reg_x+1)).includes?(cycle % 40 - 1)
    return '#'
  else
    return '.'
  end
end


input.split('\n', remove_empty: true).each do |line|
  # puts line

  if line.starts_with? "add"
    num = line.gsub("addx ", "").to_i

    cycle += 1
    # Begin cycle 1
    reg_states << reg_x
    pixels << draw_pixel(cycle, reg_x)
    # puts "reg_states[#{cycle}] = #{reg_states[cycle]}"
    # end cycle 1

    cycle += 1
    # Begin cycle 2
    reg_states << reg_x
    pixels << draw_pixel(cycle, reg_x)
    # puts "reg_states[#{cycle}] = #{reg_states[cycle]}"
    # End cycle 2

    reg_x += num
  else
    cycle += 1
    # Begin cycle
    reg_states << reg_x
    pixels << draw_pixel(cycle, reg_x)
    # puts "reg_states[#{cycle}] = #{reg_states[cycle]}"
    # End cycle
  end
end

response = 20 * reg_states[20]
response += 60 * reg_states[60]
response += 100 * reg_states[100]
response += 140 * reg_states[140]
response += 180 * reg_states[180]
response += 220 * reg_states[220]

puts "Part 1:"
pp response

puts "\nPart 2:"
puts pixels[0..39].join("")
puts pixels[40..79].join("")
puts pixels[80..119].join("")
puts pixels[120..159].join("")
puts pixels[160..199].join("")
puts pixels[200..239].join("")
