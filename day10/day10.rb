#!/usr/bin/env ruby

if ARGV.length != 1
  puts 'Usage: day10.rb <input file>'
  exit(1)
end

adapters = File.readlines(ARGV[0]).map(&:strip).reject(&:empty?).map(&:to_i)

adapters.prepend(0)
sorted_adapters = adapters.sort
sorted_adapters.append(adapters.max + 3)

puts "adapters: #{adapters}"
puts "sorted_adapters: #{sorted_adapters}"

one_diffs = 0
three_diffs = 0

sorted_adapters.each_with_index do |a, idx|
  b = sorted_adapters[idx + 1]

  unless b.nil?
    if b - a == 1
      one_diffs += 1
    else
      three_diffs += 1
    end
  end
end

puts "one_diffs: #{one_diffs}"
puts "three_diffs: #{three_diffs}"
puts "result: #{one_diffs * three_diffs}"

# part 2
adapters_with_paths = sorted_adapters.map { |adapter| [adapter, 0] }

#noinspection RubyModifiedFrozenObject
adapters_with_paths[0][1] = 1

adapters_with_paths.each_with_index do |this_one, idx|
  hits = adapters_with_paths.drop(idx).take(4).select do |item|
    item != this_one && item[0] - this_one[0] <= 3
  end

  hits.each do |item|
    item[1] += this_one[1]
  end
end

puts "total paths: #{adapters_with_paths.last[1]}"
