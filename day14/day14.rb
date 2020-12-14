#!/usr/bin/env ruby

if ARGV.length != 1
  puts 'Usage: day14.rb <input file>'
  exit(1)
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

  matches = line.match(/^(mem\[\d+\])\s*=\s*(\d+)$/)
  unless matches
    puts "Invalid input: #{line}"
    next
  end

  address = matches[1]
  value = matches[2].to_i.to_s(2).rjust(36, '0').split(//)

  contents = memory[address].to_s(2).rjust(36, '0').split(//)

  mvc = mask.zip(value, contents)

  new_contents = mvc.map do |(m, v, c)|
    case m
    when 'X'
      v
    when '0'
      0
    when '1'
      1
    end
  end

  puts "new_contents: #{new_contents.join('')}"
  memory[address] = new_contents.join('').to_i(2)
end

memory.each do |address|
  puts "address: #{address}"
end

total = memory.values.inject(0) do |acc, value|
  acc + value
end

puts "total: #{total}"
