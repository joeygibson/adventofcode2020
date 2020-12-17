#!/usr/bin/env ruby

if ARGV.length != 1
  puts 'Usage: day17.rb <input file>'
  exit(1)
end

input = File.readlines(ARGV[0]).map(&:strip).reject(&:empty?).map { |line| line.split(//) }

board = {}

input.each_with_index do |row, r_idx|
  row.each_with_index do |state, c_idx|
    board[[c_idx, r_idx, 0]] = state == '#'
  end
end

def get_neighbors(board, col, row, layer)
  neighbors = {}

  (col - 1..col + 1).each do |c_idx|
    (row - 1..row + 1).each do |r_idx|
      (layer - 1..layer + 1).each do |z_idx|
        new_coord = [c_idx, r_idx, z_idx]
        neighbors[new_coord] = board[new_coord] || false if new_coord != [col, row, layer]
      end
    end
  end

  neighbors
end

def turn(board)
  new_board = {}

  board.each do |coords, active|
    col, row, layer = coords
    neighbors = get_neighbors(board, col, row, layer)
    active_neighbors = neighbors.values.count do |state|
      state
    end

    new_board[coords] = if active
                          [2, 3].include?(active_neighbors)
                        else
                          active_neighbors == 3
                        end

    neighbors.each do |neighbor, state|
      new_board[neighbor] = state if new_board[neighbor].nil?
    end
  end

  new_board
end

puts "initial state, active: #{board.count { |k, v| v }}"

6.times do |iteration|
  board = turn(board)
  puts "iteration: #{iteration}, active: #{board.count { |k, v| v }}"
  # puts board
end
