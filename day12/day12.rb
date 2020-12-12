#!/usr/bin/env ruby
#
# The ship starts by facing east. Only the L and R actions change
# the direction the ship is facing. (That is, if the ship is
# facing east and the next instruction is N10, the ship would
# move north 10 units, but would still move east if the following action were F.)

if ARGV.length != 1
  puts 'Usage: day12.rb <input file>'
  exit(1)
end

input = File.readlines(ARGV[0]).map(&:strip).reject(&:empty?).map do |line|
  matches = line.match(/^(\w)(\d+)$/)
  [matches[1], matches[2]]
end

orientation = 90
pos = [0, 0]

input.each do |command|
  op = command[0]
  units = command[1].to_i

  puts "op: #{op}, units: #{units}"
  case op
  when 'N'
    pos[1] += units
  when 'S'
    pos[1] -= units
  when 'E'
    pos[0] += units
  when 'W'
    pos[0] -= units
  when 'L'
    orientation -= units
    if orientation.negative?
      orientation = 360 + orientation
    end
  when 'R'
    orientation += units
    if orientation >= 360
      orientation -= 360
    end
  when 'F'
    case orientation
    when 0
      pos[1] += units
    when 180
      pos[1] -= units
    when 90
      pos[0] += units
    when 270
      pos[0] -= units
    end
  else
    puts "bad input"
  end

  puts "\t\tpos: #{pos}, orientation: #{orientation}"
end

x_abs = pos[0].abs
y_abs = pos[1].abs

puts "orientation: #{orientation}"
puts "pos: (#{x_abs}, #{y_abs})"
puts "Manhattan distance: #{x_abs + y_abs}"
