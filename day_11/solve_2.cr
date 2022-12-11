INPUT = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end


struct Monkey
  property items : Array(UInt64)

  property operator : String
  property operand : UInt64?

  property div_by : UInt64
  property dest_true : UInt64
  property dest_false : UInt64

  def initialize(@items, @operator, _operand, @div_by, @dest_true, @dest_false)
    @operand = _operand == "old" ? nil : _operand.to_u64
  end

  def receive(item)
    @items << item
  end

  def turn
    thrown = 0
  
    @items.each do |item|
      oper_by = @operand.try &.to_u64 || item

      # Inspection
      case operator
      when "+" then item += oper_by
      when "*" then item *= oper_by
      end

      if item == 0
        MONKEYS[@dest_true].receive(0_u64)
      else
        destination = (item % @div_by) == 0 ? @dest_true : @dest_false
        MONKEYS[destination].receive(item % COMMON_DEN)
      end

      thrown += 1
    end

	# Monkey has no item left
    @items.clear

    # Return the amount of items thrown
    return thrown.to_u64
  end
end


MONKEYS = INPUT.split("\n\n", remove_empty: true).map do |block|
  lines = block.split('\n')

  items = lines[1].gsub("  Starting items: ", "").split(", ").map &.to_u64

  match = /(?<op>[-+*\/]) (?<other>\w+)$/.match(lines[2])
  operator = match.try &.["op"]
  operand = match.try &.["other"]

  raise Exception.new if operator.nil? || operand.nil?
 
  div_by = lines[3].gsub("  Test: divisible by ", "").to_u64
  if_true = lines[4].gsub("    If true: throw to monkey ", "").to_u64
  if_false = lines[5].gsub("    If false: throw to monkey ", "").to_u64

  Monkey.new(items, operator, operand, div_by, if_true, if_false)
end

COMMON_DEN = MONKEYS.map(&.div_by).product


monkeys_count = MONKEYS.map { |_| 0_u64 }


10_000.times do |i|
  MONKEYS.each_with_index do |monkey, j|
    thrown = monkey.turn
    monkeys_count[j] += thrown

    # puts "  - Monkey { inspected #{thrown} items"
  end

  if i == 0 || i == 19 || (i+1) % 100 == 0
    puts "== After round #{i+1} =="
    MONKEYS.each_with_index do |_, j|
      puts "Monkey #{j} inspected items #{monkeys_count[j]} times."
    end
  end
end

puts "Part 2:"
pp monkeys_count.sort.pop(2).product
