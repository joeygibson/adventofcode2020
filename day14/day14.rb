#!/usr/bin/env ruby

require 'matrix'

if ARGV.length != 1
  puts 'Usage: day14.rb <input file>'
  exit(1)
end

def map_addresses(original_address, mask)
  bits = original_address.to_i.to_s(2).rjust(36, '0').split(//)

  x_count = mask.count { |m| m == 'X' }
  x_exp = 2**x_count

  xs_seen = 0

  new_addresses = mask.zip(bits).map do |m_b|
    m = m_b[0]
    b = m_b[1]
    case m
    when '0'
      Array.new(x_exp, b)
    when '1'
      Array.new(x_exp, '1')
    when 'X'
      xs_seen += 1
      grouping = x_exp >> xs_seen

      grp = [0, 1].flat_map do |i|
        Array.new(grouping, i)
      end

      grp * (2**(xs_seen - 1))
    end
  end

  m = Matrix.rows(new_addresses)

  new_addresses[0].length.times.map do |idx|
    # s = m.column(idx).to_a.join('')
    # puts "m: #{s} = #{s.to_i(2)}"
    m.column(idx).to_a.join('').to_i(2)
  end
end

memory = Hash.new(0)

input = File.readlines(ARGV[0]).map(&:strip).reject(&:empty?)

mask = nil

input.each do |line|
  matches = line.match(/^mask\s*=\s*([X10]+)$/)
  if matches
    mask = matches[1].split(//)
    next
  end

  matches = line.match(/^mem\[(\d+)\]\s*=\s*(\d+)$/)
  unless matches
    puts "Invalid input: #{line}"
    next
  end

  address = matches[1]

  addresses_to_write = map_addresses(address, mask)

  value = matches[2].to_i

  addresses_to_write.each do |address|
    memory[address] = value
  end
end

# memory.each do |address|
#   puts "address: #{address}"
# end

total = memory.values.inject(0) do |acc, value|
  acc + value
end

puts "total: #{total}"
