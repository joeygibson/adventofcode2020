#!/usr/bin/env ruby

numbers = File.readlines('input.txt').map(&:strip).reject(&:empty?).map(&:to_i)

numbers_to_take = 25

def sum_numbers(numbers)
  numbers.flat_map do |num0|
    numbers.reject { |num1| num1 == num0 }.map do |num1|
      num0 + num1
    end
  end
end

numbers.drop(numbers_to_take).each_with_index do |number, index|
  sums = sum_numbers(numbers.drop(index).take(numbers_to_take))

  unless sums.include?(number)
    puts "considering: #{sums}"
    puts "hit: #{number}"
    break
  end
end


