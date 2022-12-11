INPUT = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end


struct Monkey
  property items : Array(Int32)

  property operator : String
  property operand : Int32?

  property div_by : Int32
  property dest_true : Int32
  property dest_false : Int32

  def initialize(@items, @operator, _operand, @div_by, @dest_true, @dest_false)
    @operand = _operand == "old" ? nil : _operand.to_i
  end

  def receive(item)
    @items << item
  end

  def turn
    thrown = 0
  
    @items.each do |item|
      oper_by = @operand.try &.to_i || item

      # Inspection
      case operator
      when "+" then item += oper_by
      when "-" then item -= oper_by
      when "*" then item *= oper_by
      when "/" then item //= oper_by
      end

      item //= 3 # Relief

      destination = (item % @div_by) == 0 ? @dest_true : @dest_false
      MONKEYS[destination].receive(item)
      thrown += 1
    end

	# Monkey has no item left
    @items.clear

    # Return the amount of items thrown
    return thrown
  end
end


MONKEYS = INPUT.split("\n\n", remove_empty: true).map do |block|
  lines = block.split('\n')

  items = lines[1].gsub("  Starting items: ", "").split(", ").map &.to_i

  match = /(?<op>[-+*\/]) (?<other>\w+)$/.match(lines[2])
  operator = match.try &.["op"]
  operand = match.try &.["other"]

  raise Exception.new if operator.nil? || operand.nil?
 
  div_by = lines[3].gsub("  Test: divisible by ", "").to_i
  if_true = lines[4].gsub("    If true: throw to monkey ", "").to_i
  if_false = lines[5].gsub("    If false: throw to monkey ", "").to_i

  Monkey.new(items, operator, operand, div_by, if_true, if_false)
end


monkeys_count = MONKEYS.map { |_| 0 }


20.times do |i|
  # puts "Round #{i}:"

  MONKEYS.each_with_index do |monkey, j|
    thrown = monkey.turn
    monkeys_count[j] += thrown

    # puts "  - Monkey { inspected #{thrown} items"
  end

  puts "After round #{i+1}, the monkeys are holding items with these worry levels:"
  MONKEYS.each_with_index do |_, j|
    puts "Monkey #{j}: #{MONKEYS[j].items.join(", ")}"
  end
end

puts "Part 1:"
pp monkeys_count.sort
