#!/usr/bin/env ruby

require 'set'

if ARGV.length != 1
  puts "Usage: #{__FILE__} <input file>"
  exit(1)
end

input = File.readlines(ARGV[0]).map(&:strip)

ing_and_all = input.map do |line|
  chunks = line.split(' (contains')
  ingredients = chunks[0].split(/ /).map(&:strip)

  allergens = chunks[1].chop.split(/,/)
                       .map(&:strip)
                       .reject(&:empty?)

  [ingredients, allergens]
end

i_to_a = Hash.new { Set.new }
a_to_i = Hash.new { Hash.new { 0 } }

ing_and_all.each do |ingredients, allergens|
  allergens.each do |allergen|
    a2i = a_to_i[allergen]

    ingredients.each do |ingredient|
      a2i[ingredient] += 1

      i2a = i_to_a[ingredient]
      i2a << allergen
      i_to_a[ingredient] = i2a
    end

    a_to_i[allergen] = a2i
  end
end

puts "#{a_to_i}"