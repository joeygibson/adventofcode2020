#!/usr/bin/env ruby

the_map = File.readlines('input.txt').map(&:strip)

def count_trees(the_map, move_right, move_down)
  off_the_map_right = the_map[0].length - 1
  off_the_map_bottom = the_map.length - 1

  col = 0
  row = 0
  trees = 0

  while row < off_the_map_bottom
    col += move_right
    row += move_down

    col -= (off_the_map_right + 1) if col > off_the_map_right

    trees += 1 if the_map[row][col] == '#'
  end

  puts "move_right = #{move_right}, move_down = #{move_down}, trees = #{trees}"
  trees
end

puts "Part 1 Trees: #{count_trees(the_map, 3, 1)}"

pairs = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]

total_trees = pairs.inject(1) do |total, pair|
  total * count_trees(the_map, pair[0], pair[1])
end

puts "Part 2 Trees: #{total_trees}"



