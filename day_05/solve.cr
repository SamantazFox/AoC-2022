input = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end

struct Instruction
  getter count : Int32
  getter src : String
  getter dst : String

  def initialize(count, @src, @dst)
    @count = count.to_i
  end

  def run(stack)
    count.times do 
      stack[dst] << stack[src].pop
    end
  end
end


initial_placement = [] of String
instructions = [] of Instruction


input.split('\n', remove_empty: true).compact_map do |line|
  if line.starts_with? /[\[ ]/
    initial_placement << line

  elsif match = /move (?<count>\d+) from (?<src>\d+) to (?<dst>\d+)/.match(line)
    count = match["count"]?
    src = match["src"]?
    dst = match["dst"]?

    if count.nil? || src.nil? || dst.nil?
      raise Exception.new "Uh oh..."
    end

    instructions << Instruction.new(count, src, dst)
  end
end


class MyStack # < Reference
  getter stack = {} of String => Array(String)

  def [](key : String)
    @stack[key]
  end

  def []=(key : String, value)
    @stack[key] = value
  end

  def pop
    @stack.pop(1)
  end

  def top_crates
    (1..9).map do |i|
      @stack["#{i}"].last
    end
  end
end


stack = MyStack.new

9.times do |i|
  offset = i*4 + 1

  id, *crates = initial_placement.reverse
    .map(&.byte_slice(offset, 1))
    .select(&.!= " ")

  stack[id] = crates
end

instructions.each do |is|
  is.run(stack)
end


puts "Part 1:"
puts stack.top_crates.join("")
