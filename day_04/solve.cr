input = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end


assignments = input.split('\n', remove_empty: true).map do |pair|
  elf_1, elf_2 = pair.split(',').map do |elf|
    start, stop = elf.split('-').map(&.to_i)
    (start..stop).to_a
  end

  [elf_1, elf_2]
end

overlaps = 0

assignments.each do |pair|
  elf_1, elf_2 = pair
  common = elf_1 & elf_2

  overlaps += 1 if common == elf_1 || common == elf_2
end


puts "Part 1:"
pp overlaps
