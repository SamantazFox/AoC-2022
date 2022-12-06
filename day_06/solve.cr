input = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end


stream = input.split('\n', remove_empty: true)[0]

packet_start = -1

(stream.size - 4).times do |i|
  bytes = stream.byte_slice(i, 4).split("").uniq

  if bytes.size == 4
    packet_start = i+4
    break
  end
end

puts "Part 1:"
pp packet_start


message_start = -1

(stream.size - 14).times do |i|
  bytes = stream.byte_slice(i, 14).split("").uniq

  if bytes.size == 14
    message_start = i+14
    break
  end
end


puts "\nPart 2:"
pp message_start
