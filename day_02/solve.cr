input = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end

enum Shape
  Rock = 1
  Paper = 2
  Scissors = 3
end

def shapeify(c : String)
  case c
  when "A", "X" then return Shape::Rock
  when "B", "Y" then return Shape::Paper
  when "C", "Z" then return Shape::Scissors
  else
    raise Exception.new "Unknown shape #{c}"
  end
end

def shape_score(s : Shape)
  return s.to_i
end

enum Outcome
  Lost = 0
  Draw = 1
  Win = 2
end

def outcome(me : Shape, other : Shape)
  return Outcome::Draw if me == other

  return Outcome::Lost if me.rock? && other.paper?
  return Outcome::Lost if me.paper? && other.scissors?
  return Outcome::Lost if me.scissors? && other.rock?

  return Outcome::Win if other.rock? && me.paper?
  return Outcome::Win if other.paper? && me.scissors?
  return Outcome::Win if other.scissors? && me.rock?

  raise Exception.new "Impossible!!"
end

def outcome_score(me : Shape, other : Shape)
  return outcome(me, other).to_i * 3
end


total = 0

input.split("\n").map do |round|
  next if round.empty?
  opponent, me = round.split(' ').map { |i| shapeify(i) }

  total += shape_score(me)
  total += outcome_score(me, opponent)
end


puts "Part 1:"
pp total
