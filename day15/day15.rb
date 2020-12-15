#!/usr/bin/env ruby

if ARGV.length != 2
  puts 'Usage: day15.rb <input file> <iterations>'
  exit(1)
end

iterations = ARGV[1].to_i
spoken_numbers = {}
last_spoken = nil

starting_numbers = File.read(ARGV[0]).split(',').reject(&:empty?).map(&:strip).map(&:to_i)

starting_numbers.each_with_index do |num, idx|
  bucket = spoken_numbers[num.to_s] || []
  bucket << idx + 1
  spoken_numbers[num] = bucket
  last_spoken = num
end

starting_length = starting_numbers.length + 1

(starting_length..iterations).each do |turn|
  last_time_spoken = spoken_numbers[last_spoken]

  last_spoken = if last_time_spoken.empty? ||
    (last_time_spoken.length == 1 && last_time_spoken.last == turn - 1) # never spoken before
                  0
                else
                  count = last_time_spoken.length
                  last_time_spoken[count - 1] - last_time_spoken[count - 2]
                end

  bucket = spoken_numbers[last_spoken] || []
  bucket << turn
  spoken_numbers[last_spoken] = bucket
end

puts "#{iterations}th spoken number: #{last_spoken}"
