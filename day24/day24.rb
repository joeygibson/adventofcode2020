#!/usr/bin/env ruby

require 'set'

if ARGV.length != 1
  puts "Usage: #{__FILE__} <input file>"
  exit(1)
end

def generate_neighbor_wheel(tile)
  [
    [tile[0] + 1, tile[1]], # e
    [tile[0], tile[1] + 1], # se
    [tile[0] - 1, tile[1] + 1], # sw
    [tile[0] - 1, tile[1]], # w
    [tile[0], tile[1] - 1], # nw
    [tile[0] + 1, tile[1] - 1] # ne
  ]
end

def get_neighbors(tiles, tile)
  neighbors = {}

  neighbor_wheel = generate_neighbor_wheel(tile)

  neighbor_wheel.each do |neighbor|
    neighbors[neighbor] = tiles[neighbor]
  end

  neighbors
end

tiles = Hash.new { :white }

input = File.readlines(ARGV[0]).map(&:strip).reject(&:empty?)

input.map do |line|
  moves = line.scan(/e|w|ne|nw|se|sw/)

  dest_tile = moves.inject [0, 0] do |tile, move|
    case move
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
  end

  current_state = tiles[dest_tile]
  tiles[dest_tile] = if current_state == :white
                       :black
                     else
                       :white
                     end
end

black_tiles = tiles.values.count { |tile| tile == :black }

puts "part 1: black_tiles: #{black_tiles}\n\n"

def day(tiles, should_flip = true)
  new_tiles = Hash.new { :white }
  set_this_time = Set.new

  tiles.each do |tile, current_state|
    neighbors = get_neighbors(tiles, tile)

    if should_flip
      black_tiles = neighbors.values.count { |state| state == :black }

      new_tiles[tile] = if current_state == :black && (black_tiles.zero? || black_tiles > 2)
                          :white
                        elsif current_state == :white && black_tiles == 2
                          :black
                        else
                          current_state
                        end
      set_this_time << tile
    else
      new_tiles[tile] = current_state
    end

    neighbors.each do |neighbor, state|
      new_tiles[neighbor] = state unless set_this_time.member?(neighbor)
    end
  end

  new_tiles
end

tiles = day(tiles, false)

(1..100).each do |d|
  tiles = day(tiles)
  black_tiles = tiles.values.count { |tile| tile == :black }
  puts "part 2, day: #{d}, black_tiles: #{black_tiles}"
end
