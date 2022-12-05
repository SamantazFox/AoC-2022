input = File.open("#{__DIR__}/input_1.txt") do |file|
  file.gets_to_end
end

elves = input.split("\n\n")
calories = elves.map do |i|
  i.split('\n', remove_empty: true).map(&.to_i).sum
end

pp calories.max
