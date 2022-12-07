require "colorize"

input = File.open("#{__DIR__}/input.txt") do |file|
  file.gets_to_end
end


BIG_FOLDERS = [] of XDir


enum XType
  File
  Dir
end

abstract class FileOrDir
  getter name : String
  getter size : Int64 = -1_i64

  def initialize(@name)
  end
end

class XFile < FileOrDir
  def compute_size
    return self.size
  end

  def initialize(@name, @size = 0_i64)
  end

  def dump(indent = 0)
    x = String.build do |str|
      str << "  " * indent
      str << "- #{@name} ("
      str << "file".colorize(:green)
      str << ", size=" 
      str << @size.colorize(:green)
      str << ')'
    end

    puts x
  end
end  

class XDir < FileOrDir
  @children = [] of (XFile | XDir)

  def compute_size : Int64
    return @size if @size != -1

    total = 0_i64

    # Children file sizes
    @children.each do |node|
      case node
      when .is_a?(XDir)  then total += node.compute_size
      when .is_a?(XFile) then total += node.size
      end
    end

	if total < 100_000
	  BIG_FOLDERS << self
	end 
    
    @size = total
    return total
  end

  def dump(indent = 0)
    x = String.build do |str|
      str << "  " * indent
      str << "- #{@name} ("
      str << "dir".colorize(:blue) 
      str << ", size=" 
      str << @size.colorize(:green)
      str << ')'
    end

    puts x
    @children.each &.dump(indent+1)
  end

  def add_node(path, name, _size)
    if path.size == 0
      return if @children.select(&.name.== name)[0]?

      if _size == "dir"
        # puts "Add #{"dir".colorize(:green)} #{name}"
        @children << XDir.new(name)
      else
        # puts "Add #{"file".colorize(:green)} #{name} (#{_size})"
        @children << XFile.new(name, _size.to_i64)
      end

    else
      child_name = path.shift

      @children
        .select(XDir)
        .select(&.name.== child_name)[0]?
        .try &.add_node(path.dup, name, _size)
    end
  end
end


path = [] of String

filesystem = XDir.new("root")

input.split("$ ", remove_empty: true).each do |cmd_with_output|
  cmd, *lines = cmd_with_output.split('\n', remove_empty: true)

  if cmd == "cd /"
    # puts "Path reset".colorize(:red)
    path = [] of String

  elsif cmd == "cd .."
    # puts "cd .. => #{path}".colorize(:yellow)
    path.pop(1)

  elsif cmd.starts_with? "cd "
    dir = cmd.gsub("cd ", "")
    path << dir
    # puts "cd => #{dir}: #{path}".colorize(:yellow)

  elsif cmd == "ls"
    lines.each do |line|
      if match = /^(?<size>\d+|dir) (?<name>.+)/.match(line)
        name = match.try &.["name"]?
        raise Exception.new if name.nil?

        _size = match.try &.["size"]?
        raise Exception.new if _size.nil?

        # puts "#{path} / #{name} / #{_size}"

        filesystem.add_node(path.dup, name, _size)

      else
        raise Exception.new "Unsupported command #{line}"
      end
    end
  end
end

filesystem.compute_size

puts "Part 1:"
#pp filesystem.dump
#pp big_folders.inspect
pp BIG_FOLDERS.map(&.size).sum
