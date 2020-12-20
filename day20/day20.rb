#!/usr/bin/env ruby

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

raw_edges = tiles.flat_map do |tile_id, tile|
  edges = {}

  edges[:top] = tile[0]
  edges[:bottom] = tile[-1]
  edges[:left] = get_column(tile, 0)
  edges[:right] = get_column(tile, -1)

  [tile_id, edges]
end

edges = Hash[raw_edges.each_slice(2).to_a]

edges.each do |tile_id, tile_edges|
  edges.reject {|id| id == tile_id}.each do |tile_id1, tile_edges1|
    tile_edges.each do |dir, edge|
      tile_edges1.each do |dir1, edge1|
        puts "match: #{tile_id} #{dir},\t#{tile_id1}, #{dir1},\t#{edge}" if edge == edge1
      end
    end
  end
end