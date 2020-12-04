#!/usr/bin/env ruby

the_map = File.readlines('input.txt').map(&:strip)

off_the_map_right = the_map[0].length - 1
off_the_map_bottom = the_map.length - 1

move_right = 3
move_down = 1

col = 0
row = 0
trees = 0

while row < off_the_map_bottom
  col += move_right
  row += move_down

  col -= (off_the_map_right + 1) if col > off_the_map_right

  trees += 1 if the_map[row][col] == '#'
end

puts "Trees: #{trees}"
