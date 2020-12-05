#!/usr/bin/env ruby

rows = Array(0..127)
seats = Array(0..7)

boarding_passes = File.readlines('input.txt').map(&:strip)

def bisect(arr, boarding_pass)
  sub = arr

  boarding_pass.each do |letter|
    lo, hi = if %w[F L].include?(letter)
               [0, sub.length / 2 - 1]
             else
               [sub.length / 2, sub.length - 1]
             end

    return sub[lo] if lo == hi

    sub = sub[lo..hi]
  end
end

seat_ids = boarding_passes.map do |boarding_pass|
  selected_row = bisect(rows, boarding_pass.split(//).take(7))
  selected_seat = bisect(seats, boarding_pass.split(//).drop(7))

  selected_row * 8 + selected_seat

  # puts "BP: #{boarding_pass}, row: #{selected_row}, seat: #{selected_seat} id: #{seat_id}"
end

highest_id = seat_ids.sort.reverse.first

puts "highest_id: #{highest_id}"



