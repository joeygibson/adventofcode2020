#!/usr/bin/env ruby

# if ARGV.length != 1
#   puts 'Usage: day11.rb <input file>'
#   exit(1)
# end

def print_seats(iteration, seats)
  puts "Iteration: #{iteration}\n"
  seats.each { |row| puts row.map {|col| col.sub('.', ' ')}.to_s }
end

seats = File.readlines(ARGV[0]).map(&:strip).reject(&:empty?).map { |line| line.split(//) }
pristine_seats = seats.clone

def load_board(which)
  File.readlines("#{which}.txt").map(&:strip).reject(&:empty?).map { |line| line.split(//) }
end

def generate_coordinate_wheel(row_i, col_i, distance)
  [[row_i - distance, col_i, :north], # north
   [row_i - distance, col_i + distance, :northeast], # northeast
   [row_i, col_i + distance, :east], # east
   [row_i + distance, col_i + distance, :southeast], # southeast
   [row_i + distance, col_i, :south], # south
   [row_i + distance, col_i - distance, :southwest], # southwest
   [row_i, col_i - distance, :west], # west
   [row_i - distance, col_i - distance, :northwest]] # northwest
    .reject { |coord| coord[0].negative? || coord[1].negative? }
end

def unified_get_neighbor_count(row_i, col_i, limit, max_neighbors, seats)
  neighbor_count = 0
  directional_hits = Hash.new(0)

  (1..limit).each do |iteration|
    break if neighbor_count >= max_neighbors || directional_hits.length == 8

    neighbor_coordinates = generate_coordinate_wheel(row_i, col_i, iteration)
    valid_coordinates = neighbor_coordinates.reject do |coord|
      directional_hits[coord[2]] == 1 ||
        (coord[0] >= seats.length || coord[1] >= seats[0].length)
    end

    neighbors = valid_coordinates.map do |coord|
      row = coord[0]
      col = coord[1]

      # puts "row: #{row}, col: #{col}, seat: #{seats[row][col]}, dir: #{coord[2]}"
      [seats[row][col], coord[2]]
    end

    break if valid_coordinates.empty?

    neighbors.each do |neighbor|
      directional_hits[neighbor[1]] = 1 if neighbor[0] != '.'
    end

    neighbor_count += neighbors.count { |neighbor| neighbor[0] == '#' }
  end

  # puts "row: #{row_i}, col: #{col_i}, neighbor_count: #{neighbor_count}"
  neighbor_count
end

def turn(seats, part)
  seats.map.with_index do |row, row_i|
    row.map.with_index do |col, col_i|
      if col == '.'
        col
      else
        neighbor_count = if part == :part1
                           unified_get_neighbor_count(row_i, col_i, 1, 4, seats)
                         else
                           limit = [seats.length, seats[0].length].max
                           unified_get_neighbor_count(row_i, col_i, limit, 5, seats)
                         end

        if col == 'L' && neighbor_count.zero?
          '#'
        elsif col == '#' &&
          (part == :part1 && neighbor_count >= 4 ||
            part == :part2 && neighbor_count >= 5)
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
  seats = turn(seats, :part1)

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

puts "\n\n"
puts '-' * 80
puts "\n\n"
puts 'Part 2'
puts "\n\n"

seats = pristine_seats.clone

iteration = 0
print_seats(iteration, seats)

loop do
  iteration += 1
  old_seats = seats.clone
  seats = turn(seats, :part2)
  # board = load_board(iteration)

  # if board != seats
  #   puts "NO match!"
  #   print_seats(iteration, seats)
  #   puts '-' * 80
  #   print_seats('good', board)
  #   break
  # end

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
