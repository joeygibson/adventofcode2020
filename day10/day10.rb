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
def diffs_are_ok(list)
  x = list.take(1)[0]
  n = list.drop(1).take(1)[0]
  xs = list.drop(1)

  if n.nil?
    true
  elsif n - x > 3
    false
  else
    diffs_are_ok(xs)
  end
end

def make_combo(list)
  x = list[0]
  n = list[1]
  xs = list.drop(1)

  if n.nil?
    []
  elsif n - x > 3
    [:dead]
  else
    [x] + make_combo(xs)
  end
end

puts 'step 1'
minimum_adapters = (adapters.max + 3) / 3
combos = (minimum_adapters..sorted_adapters.length).flat_map do |size|
  combinations = sorted_adapters.combination(size).to_a

  combinations_0 = combinations.select do |combo|
    combo[0] == sorted_adapters[0] && combo.last == sorted_adapters.last
  end
  combinations_1 = combinations_0.select do |combo|
    res = diffs_are_ok(combo)
    res
  end
  combinations_1
end

puts 'step 2'
combos_0 = combos.select { |combo| combo.min == 0 && combo.max == 22 }

puts 'step 3'
combos_1 = combos_0.map do |combo|
  diffs_are_ok(combo)
end

puts 'step 4'
combos_2 = combos_0.zip(combos_1).select { |val| val[1] }

# combos_2.each {|combo| puts "#{combo}"}
puts "combos: #{combos_2.length}"
