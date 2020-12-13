#!/usr/bin/env ruby

if ARGV.length != 1
  puts 'Usage: day13.rb <input file>'
  exit(1)
end

input = File.readlines(ARGV[0]).map(&:strip).reject(&:empty?)

timestamp = input[0].to_i
buses_in_service = input[1].split(/,/).reject { |bus_id| bus_id == 'x' }.map(&:to_i)

schedule = buses_in_service.map do |bus_id|
  bus_timestamp = 0
  while bus_timestamp < timestamp
    bus_timestamp += bus_id
  end

  [bus_id, bus_timestamp]
end

earliest_bus = schedule.min { |a, b| a[1] <=> b[1] }
diff = earliest_bus[1] - timestamp

puts "schedule: #{schedule}"
puts "earliest_bus: #{earliest_bus}"
puts "answer: #{earliest_bus[0] * diff}"

