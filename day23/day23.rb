#!/usr/bin/env ruby

if ARGV.length != 2
  puts "Usage: #{__FILE__} <input file> <number of moves>"
  exit(1)
end

input = File.readlines(ARGV[0]).map(&:strip)[0].split(//).map(&:to_i)

number_of_moves = ARGV[1].to_i
pos = 0
min_value = input.min
max_value = input.max

number_of_moves.times do
  current = input[pos]
  start = pos + 1
  stop = pos + 3
  indexes = *(start..stop).map do |idx|
    if idx >= input.length
      idx - input.length
    else
      idx
    end
  end

  next_three = indexes.map do |idx|
    input[idx]
  end

  orig_input = input.clone
  input = input.reject.with_index { |_, idx| indexes.include?(idx) }

  dest = if current - 1 < min_value
           puts "current - 1 = #{current - 1}"
           max_value
         else
           puts "current = #{current}"
           current - 1
         end

  while next_three.include?(dest)
    dest -= 1
    dest = max_value if dest < min_value
  end

  dest_idx = input.index { |cup| cup == dest }

  puts "input: #{orig_input}, pos: #{pos}, current: #{current}, next_three: #{next_three}, dest: #{dest}, dest_idx: #{dest_idx}"

  input.insert(dest_idx + 1, *next_three)
  pos = if dest_idx < pos
          pos + 4
        else
          pos + 1
        end
  pos = 0 if pos >= input.length
end

puts "final: #{input}"

one_idx = input.index { |cup| cup == 1 }
pos = one_idx + 1

results = []

while results.length < (input.length)
  if pos > input.length
    pos = 0
  end

  results << input[pos]
  pos += 1
end

puts "res: #{results.join('')}"



