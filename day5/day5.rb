#!/usr/bin/env ruby

rows = Array(0..127)
seats = Array(0..7)

boarding_passes = File.readlines('input.txt').map(&:strip)

boarding_passes.map do |boarding_pass|
  sub_rows = rows

  selected_row = nil
  selected_seat = nil

  boarding_pass.split(//).take(7).each do |letter|
    lo, hi = if letter == 'F'
               [0, sub_rows.length / 2 - 1]
             else
               [sub_rows.length / 2, sub_rows.length - 1]
             end

    if lo == hi
      selected_row = sub_rows[lo]
    else
      sub_rows = sub_rows[lo..hi]
    end
  end

  sub_rows = seats
  boarding_pass.split(//).drop(7).each do |letter|
    lo, hi = if letter == 'L'
               [0, sub_rows.length / 2 - 1]
             else
               [sub_rows.length / 2, sub_rows.length - 1]
             end

    if lo == hi
      selected_seat = sub_rows[lo]
    else
      sub_rows = sub_rows[lo..hi]
    end
  end

  seat_id = selected_row * 8 + selected_seat

  if boarding_pass == 'BFFFBBFRRR' || boarding_pass == 'FFFBBBFRRR' || boarding_pass == 'BBFFBBFRLL'
    puts "BP: #{boarding_pass}, row: #{selected_row}, seat: #{selected_seat} id: #{seat_id}"
  end
end



