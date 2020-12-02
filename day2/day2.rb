#!/usr/bin/env ruby

data = File.readlines("input.txt").filter { |line| line =~ /\d+/ }

pairs = data.map do |line|
  line.split /:/
end

results = pairs.select do |pair|
  policy = pair[0]
  password = pair[1].strip

  range, letter = policy.split /\s+/
  lower, upper = range.split /-/

  count = password.count(letter)

  count >= lower.to_i && count <= upper.to_i
end

puts "Results: #{results.length}"

results = pairs.select do |pair|
  policy = pair[0]
  password = pair[1].strip

  range, letter = policy.split /\s+/
  lower, upper = range.split /-/

  lower_equals = password[lower.to_i - 1] == letter
  upper_equals = password[upper.to_i - 1] == letter
  
  (lower_equals || upper_equals) && !(lower_equals && upper_equals)
end

puts "Results: #{results.length}"
