input = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end

reg_x = 1
cycle = 0
reg_states = [1] # Init with cycle 0


input.split('\n', remove_empty: true).each do |line|
  # puts line

  if line.starts_with? "add"
    num = line.gsub("addx ", "").to_i

    cycle += 1
    reg_states << reg_x
    # puts "reg_states[#{cycle}] = #{reg_states[cycle]}"

    cycle += 1
    reg_states << reg_x
    # puts "reg_states[#{cycle}] = #{reg_states[cycle]}"
    reg_x += num
  else
    cycle += 1
    reg_states << reg_x
    # puts "reg_states[#{cycle}] = #{reg_states[cycle]}"
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
