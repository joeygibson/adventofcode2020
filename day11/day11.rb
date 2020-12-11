#!/usr/bin/env ruby

if ARGV.length != 1
  puts 'Usage: day11.rb <input file>'
  exit(1)
end

def print_seats(iteration, seats)
  puts "Iteration: #{iteration}\n"
  seats.each { |row| puts row.to_s }
end

seats = File.readlines(ARGV[0]).map(&:strip).reject(&:empty?).map { |line| line.split(//) }

def get_neighbor_count(row_i, col_i, seats)
  neighbor_count = 0
  (-1..1).each do |i|
    new_r = row_i + i
    next if new_r.negative? || new_r >= seats.length

    (-1..1).each do |j|
      new_c = col_i + j

      next if new_c.negative? || new_c >= seats[0].length

      if new_r == row_i && new_c == col_i
        next
      end

      neighbor = seats[new_r][new_c]

      neighbor_count += 1 if neighbor == '#'
    end
  end

  neighbor_count
end

def turn(seats)
  seats.map.with_index do |row, row_i|
    row.map.with_index do |col, col_i|
      if col == '.'
        col
      else
        neighbor_count = get_neighbor_count(row_i, col_i, seats)

        if col == 'L' && neighbor_count.zero?
          '#'
        elsif col == '#' && neighbor_count >= 4
          'L'
        else
          col
        end
      end
    end
  end
end

iteration = 0
print_seats(iteration, seats)

loop do
  iteration += 1
  old_seats = seats.clone
  seats = turn(seats)

  if seats == old_seats
    occupied_seats = seats.inject(0) do |seat_count, row|
      seat_count + row.count { |seat| seat == '#' }
    end

    puts
    puts "Done. Occupied seats: #{occupied_seats}"
    break
  end

  puts '-' * 80
  print_seats(iteration, seats)
  puts
end
