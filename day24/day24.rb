#!/usr/bin/env ruby

class Tile
  include Comparable
  attr_accessor :row, :col

  def initialize(col = 0, row = 0)
    @col = col
    @row = row
  end

  def to_s
    "col: #{@col}, row: #{@row}"
  end

  def ==(other)
    @col == other.col && @row == other.row
  end

  def hash
    @col.hash + @row.hash
  end

  def <=>(other)
    rc = @col <=> other.col
    if rc.zero?
      @row <=> other.row
    else
      rc
    end
  end
end

if ARGV.length != 1
  puts "Usage: #{__FILE__} <input file>"
  exit(1)
end

tiles = Hash.new { :white }
seen = Hash.new { 0 }

input = File.readlines(ARGV[0]).map(&:strip).reject(&:empty?)

input.map do |line|
  moves = line.scan(/e|w|ne|nw|se|sw/)

  dest_tile = moves.inject Tile.new do |tile, move|
    dest = case move
           when 'e'
             Tile.new(tile.col + 1, tile.row)
           when 'se'
             Tile.new(tile.col, tile.row + 1)
           when 'sw'
             Tile.new(tile.col - 1, tile.row + 1)
           when 'w'
             Tile.new(tile.col - 1, tile.row)
           when 'nw'
             Tile.new(tile.col, tile.row - 1)
           when 'ne'
             Tile.new(tile.col + 1, tile.row - 1)
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
                       puts 'BLACK!'
                       :white
                     end

  seen
  puts "#{dest_tile}, old: #{current_state}, current: #{tiles[dest_tile]}"
end

puts "seen: #{seen.length}"

tiles.keys.sort.each { |key| puts "key: #{key}, hash: #{key.hash}" }

