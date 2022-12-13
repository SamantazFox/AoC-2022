#require "./test_input"
require "./input"

# Debug
# Result: it was faster to convert to crystal than make a parser :P
#PAIRS.each do |p|
#  pp p[:a].inspect
#  pp p[:b].inspect
#  puts "\n-------------\n"
#end


def ordered?(a : Crap, b : Crap, debug = false, indent = 0)
  puts "  "*indent + "- Compare #{a} vs #{b}" if debug
  indent += 1

  if a.is_a?(Int32) && b.is_a?(Array)
    # A needs conversion
    puts "  "*indent + "- Mixed types; convert left to [#{a}] and retry comparison" if debug
    return ordered?([a] of Crap, b, debug, indent)
  elsif a.is_a?(Array) && b.is_a?(Int32)
    # B needs conversion
    puts "  "*indent + "- Mixed types; convert right to [#{b}] and retry comparison" if debug
    return ordered?(a, [b] of Crap, debug, indent)
  elsif a.is_a?(Array) && b.is_a?(Array)
    # A and B are both arrays
    [a.size, b.size].min.times do |i|
      result = ordered?(a[i], b[i], debug, indent)

      next if result.nil?
      return result
    end

    return nil if a.size == b.size

    if a.size < b.size
      puts "  "*indent + "- Left side ran out of items, so inputs are \e[1min the right order\e[0m" if debug
      return true
    end

    puts "  "*indent + "- Right side ran out of items, so inputs are \e[1mnot in the right order\e[0m" if debug
    return false
  elsif a.is_a?(Int32) && b.is_a?(Int32)
    # A and B are both integers
    return nil if a == b

    if a < b
      puts "  "*indent + "- Left side is smaller, so inputs are \e[1min the right order\e[0m" if debug
      return true
    else
      puts "  "*indent + "- Right side is smaller, so inputs are \e[1mnot in the right order\e[0m" if debug
      return false
    end
  else
    raise Exception.new "Error!! a = #{a} / b = #{b}"
  end
end


debug = false

indices = PAIRS.map_with_index do |p, i|
  puts "\n== Pair #{i+1} ==" if debug
  is_ordered = ordered?(p[:a], p[:b], debug)

  #puts "#{i} = #{is_ordered}"
  is_ordered ? i+1 : 0
end

puts "Part 1:"
pp indices.sum




all_packets = [
  [[2] of Crap] of Crap,
  [[6] of Crap] of Crap,
]

PAIRS.each do |p|
  all_packets << p[:a]
  all_packets << p[:b]
end

loop do
  swap_hapenned = false

  (all_packets.size-1).times do |i|
    a = all_packets[i]
    b = all_packets[i+1]

    if !ordered?(a, b)
      all_packets[i] = b
      all_packets[i+1] = a
      swap_hapenned = true
    end
  end

  break if swap_hapenned == false
end

pos_2 = 0
pos_6 = 0

all_packets.each_with_index do |p, i|
  pos_2 = i+1 if p == [[2] of Crap] of Crap
  pos_6 = i+1 if p == [[6] of Crap] of Crap
end

puts "\nPart 2:"
pp pos_2 * pos_6
