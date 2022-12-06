input = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end

rucksacks = input.split('\n', remove_empty: true).map do |rs|
  itm_count = rs.size // 2
  content_1 = rs[0..(itm_count-1)].chars
  content_2 = rs[itm_count..-1].chars

  common = content_1 & content_2

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
