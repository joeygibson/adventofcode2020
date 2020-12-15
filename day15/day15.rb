#!/usr/bin/env ruby

require 'matrix'

if ARGV.length != 1
  puts 'Usage: day15.rb <input file>'
  exit(1)
end

spoken_numbers = []

starting_numbers = File.read(ARGV[0]).split(',').reject(&:empty?).map(&:strip).map(&:to_i)

spoken_numbers += starting_numbers

while spoken_numbers.length < 2020
  last_spoken = spoken_numbers.last

  last_time_spoken = spoken_numbers.take(spoken_numbers.length - 1).rindex { |n| n == last_spoken }

  if last_time_spoken.nil? # never spoken before
    spoken_numbers << 0
  else
    new_index = spoken_numbers.length - 1 - last_time_spoken
    spoken_numbers << new_index
  end
end

puts "2020th spoken number: #{spoken_numbers.last}"
