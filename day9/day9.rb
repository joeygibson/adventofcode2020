#!/usr/bin/env ruby

if ARGV.length != 2
  puts 'Usage: day9.rb <input file> <preamble size>'
  exit(1)
end

numbers = File.readlines(ARGV[0]).map(&:strip).reject(&:empty?).map(&:to_i)
numbers_to_take = ARGV[1].to_i

def sum_numbers(numbers)
  numbers.flat_map do |num0|
    numbers.reject { |num1| num1 == num0 }.map do |num1|
      num0 + num1
    end
  end
end

part1_result = 0
part1_result_index = 0

numbers.drop(numbers_to_take).each_with_index do |number, index|
  sums = sum_numbers(numbers.drop(index).take(numbers_to_take))

  unless sums.include?(number)
    part1_result = number
    part1_result_index = numbers.find_index(number)
    break
  end
end

part2_result = 0

catch :found do
  (0..part1_result_index).each do |start|
    (1..part1_result_index).each do |stop|
      sum = numbers.drop(start).take(stop).sum

      if sum == part1_result
        min_val = numbers.drop(start).take(stop).min
        max_val = numbers.drop(start).take(stop).max
        
        part2_result = min_val + max_val

        throw :found
      end
    end
  end
end

puts "part 1: #{part1_result}"
puts "part 2: #{part2_result}"
