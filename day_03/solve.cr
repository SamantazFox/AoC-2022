input = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end


groups = [] of Array(String)

rucksacks = input.split('\n', remove_empty: true).map_with_index do |rs, i|
  itm_count = rs.size // 2
  content_1 = rs[0..(itm_count-1)].chars
  content_2 = rs[itm_count..-1].chars

  common = content_1 & content_2

  grp = (i // 3)
  groups << [] of String if !groups[grp]?
  groups[grp] << rs

  {
    content_1: content_1,
    content_2: content_2,
    common:    common[0],
  }
end

def priority(c : Char)
  if !c.ascii_letter?
    raise Exception.new "Unknown char #{c}"
  end

  case c.ord
  when ('a'.ord)..('z'.ord) then return (c.ord - 'a'.ord) + 1
  when ('A'.ord)..('Z'.ord) then return (c.ord - 'A'.ord) + 27
  else
    raise Exception.new "Invalid char #{c}"
  end
end

total = 0
rucksacks.each do |rs|
  total += priority(rs[:common])
end


puts "Part 1:"
pp total


badges_priorities = groups.map do |grp|
  a, b, c = grp.map(&.chars)
  common = (a & b & c)
  priority(common[0])
end

total_2 = badges_priorities.sum

puts ""
puts "Part 2:"
pp total_2
