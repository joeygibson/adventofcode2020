#!/usr/bin/env ruby

if ARGV.length != 1
  puts "Usage: #{__FILE__} <input file>"
  exit(1)
end

tiles = Hash.new { :white }

input = File.readlines(ARGV[0]).map(&:strip).reject(&:empty?)

input.map do |line|
  moves = line.scan(/e|w|ne|nw|se|sw/)

  dest_tile = moves.inject [0, 0] do |tile, move|
    dest = case move
           when 'e'

             [tile[0] + 1, tile[1]]
           when 'se'
             [tile[0], tile[1] + 1]
           when 'sw'
             [tile[0] - 1, tile[1] + 1]
           when 'w'
             [tile[0] - 1, tile[1]]
           when 'nw'
             [tile[0], tile[1] - 1]
           when 'ne'
             [tile[0] + 1, tile[1] - 1]
           else
             puts "invalid move: #{move}"
           end

    # puts "move: #{move}, start: #{tile} tile: #{dest}"
    dest
  end

  current_state = tiles[dest_tile]
  tiles[dest_tile] = if current_state == :white
                       :black
                     else
                       :white
                     end

  puts "#{dest_tile}, old: #{current_state}, current: #{tiles[dest_tile]}"
end

# tiles.keys.sort.each { |key| puts "key: #{key}, hash: #{key.hash}" }
black_tiles = tiles.values.count { |tile| tile == :black }

puts "black_tiles: #{black_tiles}"
