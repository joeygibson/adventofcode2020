#!/usr/bin/env ruby

data = File.readlines("input.txt").filter { |line| line =~ /\d+/ }.map { |item| item.to_i }

# two values
data.each do |value|
  other_values = data.reject { |item| item == value }

  match = other_values.find { |item| item + value == 2020 }

  if match
    puts "#{value} * #{match} = #{value * match}"
    break
  end
end

# three values
data.each do |value|
  data.reject { |item| item == value }.each do |second_value|
    match = data.reject { |item| item == value || item == second_value }.find { |item| item + second_value + value == 2020 }

    if match
      puts "#{value} * #{second_value} * #{match} = #{value * second_value * match}"
      break
    end
  end
end


