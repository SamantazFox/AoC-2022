input = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end

elves = input.split("\n\n")
calories = elves.map do |i|
  i.split('\n', remove_empty: true).map(&.to_i).sum
end

puts "Part 1:"
pp calories.max


puts "\nPart 2:"
pp calories.sort[-3..-1].sum
