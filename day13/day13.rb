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

puts "\n\n"
puts '-' * 80
puts "\n"
puts "part 2\n\n"

# part 2 stolen shamelessly from https://topaz.github.io/paste/#XQAAAQDjAgAAAAAAAAARiAqGkkN7pUjVWW5O/8kAHtqieaDJW/x6fZAz4dPiQJToiDdFET3JIRXOC1zTFN8lrRTYtBiOuM94vK3SDrc+EyQY/mtgIi57X6SacUcFQ7OxrHgtHERfN996gXIXrNl7uMAjllAJGHaoC+er6HZC9pBmSAwW/Rub7ZdQPcvwPatBWiTNsY/S67wDftjTA5uzND80YFd6bMC5KwMXQBs68thKgzE9cITifEa28H48s/nU9To8v0iSas7T88Errs+8CzEuLDiwPh4mH9i+gTB16zvomGABL4gigPrxbZh0B0Ck/nbLp0R4rA2QXzaLbgtPVk5W3E+s8H+K5u/OH91C1aczTUs2d0GoMgQGdv8t0XIZdyJOxl1HEStcG9nJxDErhFzoPOqo5wsySgVAvxgNDOthpvcnBULYCFE50Fe2PB0Og7X6yqHoMsDhaiiVWopZoXJhdf7nhEKy7mnDOC0S/w2F35fGhCMROEaztYL/EEJVCkvbz8cakuu1Q7atprBmMgS6h96jaTukGd1j+hoYjvOLZuG6XJxi3RvWkxIbP2fSXCS/Jd5pggwIPlIJdayq/+g3cKz/6CH7nQ==
# and https://rosettacode.org/wiki/Chinese_remainder_theorem#Ruby

def extended_gcd(a, b)
  last_remainder, remainder = a.abs, b.abs
  x, last_x, y, last_y = 0, 1, 1, 0
  while remainder != 0
    last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
    x, last_x = last_x - quotient * x, x
    y, last_y = last_y - quotient * y, y
  end
  return last_remainder, last_x * (a.negative? ? -1 : 1)
end

def invmod(e, et)
  g, x = extended_gcd(e, et)
  if g != 1
    raise 'Multiplicative inverse modulo does not exist!'
  end

  x % et
end

def chinese_remainder(mods, remainders)
  max = mods.inject(:*) # product of all moduli
  series = remainders.zip(mods).map { |r, m| (r * max * invmod(max / m, m) / m) }
  series.inject(:+) % max
end

buses = input[1].split(/,/).map { |bus| bus == 'x' ? nil : bus.to_i }

puts "buses: #{buses}"

mods = []
remainders = []

buses.each_with_index do |bus, idx|
  next if bus.nil?

  mods << bus
  remainders << (-1 * idx) % bus
end

puts chinese_remainder(mods, remainders)

## part 2 again
# translated from a Python example at https://old.reddit.com/r/adventofcode/comments/kc4njx/2020_day_13_solutions/gfnjgl4/

buses = input[1].split(/,/).map { |bus| bus == 'x' ? nil : bus.to_i }
bus_time_offsets = buses.map.with_index { |bus, idx| [bus, idx] }
                        .reject { |bus_with_idx| bus_with_idx[0].nil? }

puts "buses: #{bus_time_offsets}"

pos = 0
incr = bus_time_offsets[0][0]

bus_time_offsets.drop(1).each do |bto|
  bus_time = bto[0]
  bus_offset = bto[1]

  loop do
    pos += incr
    break if ((pos + bus_offset) % bus_time).zero?
  end

  incr *= bus_time
end

puts "pos: #{pos}"

