input = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end


stream = input.split('\n', remove_empty: true)[0]

start = -1

(stream.size - 4).times do |i|
  bytes = stream.byte_slice(i, 4).split("").uniq

  if bytes.size == 4
    start = i+4
    break
  end
end

puts "Part1 :"
pp start
