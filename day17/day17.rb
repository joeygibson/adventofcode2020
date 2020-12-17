#!/usr/bin/env ruby

if ARGV.length != 1
  puts 'Usage: day17.rb <input file>'
  exit(1)
end

class Cube
  def self.new_active(x, y, z)
    Cube.new('#', x, y, z)
  end

  def self.new_inactive
    Cube.new('.', x, y, z)
  end

  def initialize(state, x, y, z)
    @x = x
    @y = y
    @z = z
    @active = state == '#'
  end

  def flip
    @active = !@active
  end

  def is_active
    @active
  end

  def to_s
    if @active
      '#'
    else
      '.'
    end
  end
end

class Layer
  def initialize(z, arr)
    @z = z
    @cubes = arr.map.with_index do |cells, x|
      cells.map.with_index do |state, y|
        Cube.new(state, x, y, z)
      end
    end
  end

  def expand
    @cubes.each.with_index do |row, y|
      row.prepend(Cube.new_inactive, row.first.x - 1, y, @z)
      row.append(Cube.new_inactive, row.first.x - 1, y, @z)
    end

    row_length = @cubes[0].length - 1

    @cubes.prepend((0..row_length).map { |_| Cube.new_inactive })
    @cubes.append((0..row_length).map { |_| Cube.new_inactive })
  end

  def print
    @cubes.each do |row|
      puts row.join('').to_s
    end
  end

  def get_neighbor_coordinates

  end
end

class Board
  def initialize(first_layer)
    @layers = {}
    @layers[0] = first_layer
  end

  def print
    @layers.sort.each do |level, layer|
      puts "layer = #{level}"
      layer.print
      puts '-' * 40
    end
  end

  def get_neighbors() end
end

input = File.readlines(ARGV[0]).map(&:strip).reject(&:empty?).map { |line| line.split(//) }

layer = Layer.new(input)
board = Board.new(layer)

board.print

layer.expand
board.print

