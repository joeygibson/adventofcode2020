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

def reorient_waypoint(units, waypoint_offset)
  x = waypoint_offset[0]
  y = waypoint_offset[1]

  if units.negative?
    case units.abs
    when 90
      [-y, x]
    when 180
      [-x, -y]
    when 270
      [y, -x]
    when 360
      [x, y]
    end
  else
    case units.abs
    when 90
      [y, -x]
    when 180
      [-x, -y]
    when 270
      [-y, x]
    when 360
      [x, y]
    end
  end
end

waypoint_offset = [10, 1]
waypoint_pos = [10, 1]
pos = [0, 0]

puts "\t\tpos: #{pos}, waypoint_pos: #{waypoint_pos},  waypoint_offset: #{waypoint_offset}"

input.each do |command|
  op = command[0]
  units = command[1].to_i

  puts "op: #{op}, units: #{units}"
  case op
  when 'N'
    waypoint_offset[1] += units
  when 'S'
    waypoint_offset[1] -= units
  when 'E'
    waypoint_offset[0] += units
  when 'W'
    waypoint_offset[0] -= units
  when 'L'
    waypoint_offset = reorient_waypoint(-units, waypoint_offset)
    waypoint_pos[0] = pos[0] + waypoint_offset[0]
    waypoint_pos[1] = pos[1] + waypoint_offset[1]
  when 'R'
    waypoint_offset = reorient_waypoint(units, waypoint_offset)
    waypoint_pos[0] = pos[0] + waypoint_offset[0]
    waypoint_pos[1] = pos[1] + waypoint_offset[1]
  when 'F'
    pos[0] += waypoint_offset[0] * units
    pos[1] += waypoint_offset[1] * units

    waypoint_pos[0] = pos[0] + waypoint_offset[0]
    waypoint_pos[1] = pos[1] + waypoint_offset[1]
  else
    puts "bad input"
  end

  puts "\t\tpos: #{pos}, waypoint_pos: #{waypoint_pos},  waypoint_offset: #{waypoint_offset}"
end

x_abs = pos[0].abs
y_abs = pos[1].abs

puts "pos: (#{x_abs}, #{y_abs})"
puts "Manhattan distance: #{x_abs + y_abs}"
