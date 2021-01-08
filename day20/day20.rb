#!/usr/bin/env ruby

require 'set'

if ARGV.length != 1
  puts "Usage: #{__FILE__} <input file>"
  exit(1)
end

class String
  def indexes(needle)
    found = []
    current_index = -1
    while current_index = index(needle, current_index + 1)
      found << current_index
    end
    found
  end
end

class Tile
  attr_reader :id, :rows, :size

  def initialize(id, rows, size)
    @id = id
    @rows = rows
    @size = size
  end

  def self.new_from_raw(raw_data)
    lines = raw_data.split(/\n/).reject(&:empty?)
    id = lines[0].match(/^Tile (\d+):/)[1]
    rows = lines.drop(1).map(&:strip)
    size = rows.length

    Tile.new(id, rows, size)
  end

  def top
    @rows[0]
  end

  def bottom
    @rows[-1]
  end

  def left
    @rows.map { |row| row[0] }.join('')
  end

  def right
    @rows.map { |row| row[-1] }.join('')
  end

  def to_s
    @rows.join("\n")
  end

  def rotate
    split_data = @rows.map { |str| str.split(//) }

    rotated_data = []
    split_data.transpose.each do |x|
      rotated_data << x.reverse.join('')
    end

    Tile.new(@id, rotated_data, rotated_data.length)
  end

  def flip
    rows = @rows.map(&:reverse)

    Tile.new(@id, rows, @size)
  end

  def remove_edges
    rows = @rows[1..-2]
    rows = rows.map do |row|
      row[1..-2]
    end

    Tile.new(@id, rows, rows.length)
  end
end

def rotations(tile)
  first_rotation = tile.rotate
  second_rotation = first_rotation.rotate
  third_rotation = second_rotation.rotate

  [tile, first_rotation, second_rotation, third_rotation]
end

big_chunks = File.read(ARGV[0]).split(/^\s*$/)

tiles = big_chunks.flat_map do |big_chunk|
  Tile.new_from_raw(big_chunk)
end

def next_empty(grid)
  (0...grid.length).each do |y|
    (0...grid.length).each do |x|
      return [y, x] if grid[y][x].nil?
    end
  end

  [nil, nil]
end

def all_variations(tile)
  rots = rotations(tile)
  flipped_tile = tile.flip
  flipped_rots = rotations(flipped_tile)

  [rots, flipped_rots].flatten
end

def can_place(grid, y, x, t)
  if x > 0
    left_side = grid[y][x - 1]
    return false if t.left != left_side.right
  end

  if y > 0
    top_side = grid[y - 1][x]
    return false if t.top != top_side.bottom
  end

  true
end

def create_grid(size)
  grid_size = size ** 0.5
  (0...grid_size).map do
    (0...grid_size).map do
      nil
    end
  end
end

def solve(grid, tiles)
  return grid if tiles.empty?

  y, x = next_empty(grid)

  tiles.each do |next_tile|
    others = tiles.reject { |tile| tile == next_tile }

    vars = all_variations(next_tile)
    vars.each do |tile|
      next unless can_place(grid, y, x, tile)

      grid_copy = grid.map do |row|
        row.map(&:clone)
      end

      grid_copy[y][x] = tile
      solution = solve(grid_copy, others)
      return solution unless solution.nil?
    end
  end

  nil
end

grid = create_grid(tiles.length)
solved_grid = solve(grid, tiles)
corners = solved_grid[0][0].id, solved_grid[-1][0].id, solved_grid[0][-1].id, solved_grid[-1][-1].id

part1 = corners.inject(1) { |acc, id| acc * id.to_i }
puts "part1: #{part1}"

trimmed_grid = solved_grid.map do |row|
  row.map do |tile|
    tile.remove_edges
  end
end

def make_big_picture(grid)
  big_picture_arr = grid.map do |row|
    row_data = row.map do |tile|
      tile.rows
    end

    row_string = ''
    row_count = row_data[0].length

    row_count.times do |idx|
      row_data.each do |item|
        row_string << item[idx]
      end

      row_string << "\n"
    end

    row_string
  end

  big_picture_arr.join('')
end

big_picture = make_big_picture(trimmed_grid)

puts big_picture
puts "\n\n"

sea_monster = [
  '                  # '.gsub(' ', '.'),
  '#    ##    ##    ###'.gsub(' ', '.'),
  ' #  #  #  #  #  #   '.gsub(' ', '.')
]

def find_monsters(picture, sea_monster)
  first_hits = []
  lines_to_skip = []

  picture_strings = picture.split(/\n/)

  (0...picture_strings.length).each do |row_idx|
    next if lines_to_skip.member?(row_idx)

    start_indexes = picture_strings[row_idx].indexes(/#{sea_monster[0]}/)

    next if start_indexes.nil?

    start_indexes.each do |start_index|
      end_index = start_index + sea_monster[0].length

      next if row_idx + 1 >= picture_strings.length

      next_row = picture_strings[row_idx + 1][start_index..end_index]
      next unless next_row =~ /#{sea_monster[1]}/

      next if row_idx + 2 >= picture_strings.length

      next_row = picture_strings[row_idx + 2][start_index..end_index]
      next unless next_row =~ /#{sea_monster[2]}/

      first_hits << row_idx
      # lines_to_skip << row_idx + 1
      # lines_to_skip << row_idx + 2

      puts picture_strings[row_idx][start_index..end_index]
      puts picture_strings[row_idx + 1][start_index..end_index]
      puts picture_strings[row_idx + 2][start_index..end_index]
      puts "\n\n"

      # break
    end
  end

  first_hits
end

def rotate_picture(picture)
  split_data = picture.split(/\n/).map { |row| row.split(//) }

  rotated_data = []
  split_data.transpose.each do |x|
    rotated_data << x.reverse.join('')
  end

  rotated_data.join("\n")
end

def flip(picture)
  picture.split(/\n/).map(&:reverse).join("\n")
end

first_rot = rotate_picture(big_picture)
second_rot = rotate_picture(first_rot)
third_rot = rotate_picture(second_rot)

rots = [big_picture, first_rot, second_rot, third_rot]
all_variants = rots.flat_map do |picture|
  flipped = flip(picture)
  [picture, flipped]
end

all_hits = all_variants.flat_map do |picture|
  monsters = find_monsters(picture, sea_monster)
  puts "monsters: #{monsters}"

  monsters
end

hit_set = Set.new(all_hits)

puts "hits: #{hit_set}"
monster_size = 15

total_hashes = big_picture.split(//).count { |item| item == '#' }

puts "total_hashes: #{total_hashes}"
puts "part 2: #{total_hashes - (monster_size * hit_set.length)}"
