input = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end


xx = input.split('\n', remove_empty: true).map do |pair|
end





# Starting items
monkeys = [
  [91, 54, 70, 61, 64, 64, 60, 85], # 0
  [82], #1
  [84, 93, 70], # 2
  [78, 56, 85, 93], # 3
  [64, 57, 81, 95, 52, 71, 58], # 4
  [58, 71, 96, 58, 68, 90], # 5
  [56, 99, 89, 97, 81], # 6
  [68, 72], # 7
]

monkeys_count = [0,0,0,0,0,0,0,0]


20.times do |i|
  # puts "Round #{i}:"

  count = monkeys[0].size
  monkeys[0].each do |item|
    monkeys_count[0] += 1

    item *= 13 # inspect
    item //= 3 # Gets bored

    if (item % 2) == 0
      monkeys[5] << item
    else
      monkeys[2] << item
    end
  end

  monkeys[0] = [] of Int32
  # puts "  - Monkey 0 inspected #{count} items"

  count = monkeys[1].size
  monkeys[1].each do |item|
    monkeys_count[1] += 1

    item += 7 # inspect
    item //= 3 # Gets bored

    if (item % 13) == 0
      monkeys[4] << item
    else
      monkeys[3] << item
    end
  end

  monkeys[1] = [] of Int32
  # puts "  - Monkey 1 inspected #{count} items"

  count = monkeys[2].size
  monkeys[2].each do |item|
    monkeys_count[2] += 1

    item += 2 # inspect
    item //= 3 # Gets bored

    if (item % 5) == 0
      monkeys[5] << item
    else
      monkeys[1] << item
    end
  end

  monkeys[2] = [] of Int32
  # puts "  - Monkey 2 inspected #{count} items"

  count = monkeys[3].size
  monkeys[3].each do |item|
    monkeys_count[3] += 1

    item *= 2 # inspect
    item //= 3 # Gets bored

    if (item % 3) == 0
      monkeys[6] << item
    else
      monkeys[7] << item
    end
  end

  monkeys[3] = [] of Int32
  # puts "  - Monkey 3 inspected #{count} items"

  count = monkeys[4].size
  monkeys[4].each do |item|
    monkeys_count[4] += 1

    item *= item # inspect
    item //= 3 # Gets bored

    if (item % 11) == 0
      monkeys[7] << item
    else
      monkeys[3] << item
    end
  end

  monkeys[4] = [] of Int32
  # puts "  - Monkey 4 inspected #{count} items"

  count = monkeys[5].size
  monkeys[5].each do |item|
    monkeys_count[5] += 1

    item += 6 # inspect
    item //= 3 # Gets bored

    if (item % 17) == 0
      monkeys[4] << item
    else
      monkeys[1] << item
    end
  end

  monkeys[5] = [] of Int32
  # puts "  - Monkey 5 inspected #{count} items"

  count = monkeys[6].size
  monkeys[6].each do |item|
    monkeys_count[6] += 1

    item += 1 # inspect
    item //= 3 # Gets bored

    if (item % 7) == 0
      monkeys[0] << item
    else
      monkeys[2] << item
    end
  end

  monkeys[6] = [] of Int32
  # puts "  - Monkey 6 inspected #{count} items"

  count = monkeys[7].size
  monkeys[7].each do |item|
    monkeys_count[7] += 1

    item += 8 # inspect
    item //= 3 # Gets bored

    if (item % 19) == 0
      monkeys[6] << item
    else
      monkeys[0] << item
    end
  end

  monkeys[7] = [] of Int32
  # puts "  - Monkey 7 inspected #{count} items"

  # puts "After round #{i+1}, the monkeys are holding items with these worry levels:"
  # monkeys.each_with_index do |list, j|
  #   puts "Monkey #{j}: #{monkeys[j].join(", ")}"
  # end
end

puts "Part 1:"
pp monkeys_count.sort
