#!/usr/bin/env ruby

require 'set'

if ARGV.length != 1
  puts "Usage: #{__FILE__} <input file>"
  exit(1)
end

big_chunks = File.read(ARGV[0]).split(/^\s*$/)

raw_tiles = big_chunks.flat_map do |big_chunk|
  lines = big_chunk.split(/\n/).reject(&:empty?)
  tile_id = lines[0].match(/^Tile (\d+):/)[1]
  tile = lines.drop(1).map(&:strip)

  [tile_id, tile]
end

tiles = Hash[raw_tiles.each_slice(2).to_a]

def get_column(tile, col_idx)
  col = tile.map do |row|
    row.split(//)[col_idx]
  end

  col.join('')
end

unique_edges = Hash.new {0}
  #Set.new

raw_edges = tiles.flat_map do |tile_id, tile|
  edges = {}

  edges[:top] = tile[0]
  edges[:top_r] = tile[0].reverse
  edges[:bottom] = tile[-1]
  edges[:bottom_r] = tile[-1].reverse
  edges[:left] = get_column(tile, 0)
  edges[:left_r] = get_column(tile, 0).reverse
  edges[:right] = get_column(tile, -1)
  edges[:right_r] = get_column(tile, -1).reverse

  edges.each_value do |edge|
    unique_edges[edge] += 1
  end

  [tile_id, edges]
end

edges = Hash[raw_edges.each_slice(2).to_a]

ue1 = unique_edges.reject {|edge, count| count > 1}

matches = Hash.new {0}

ue1.each_key do |edge|
  edges.each do |tile_id, tile_edges|
    tile_edges.each_value do |tile_edge|
      if tile_edge == edge
        # puts "#{tile_id}" #, #{edge}"
        matches[tile_id] += 1
      end
    end
  end
end

m = matches.select do |k, v|
  v == 4
end

res = m.keys.map(&:to_i).inject(1) {|acc, e| acc * e}

puts "#{res}"
