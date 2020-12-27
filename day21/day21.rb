#!/usr/bin/env ruby

require 'set'

if ARGV.length != 1
  puts "Usage: #{__FILE__} <input file>"
  exit(1)
end

all_ingredients = Hash.new { 0 }

input = File.readlines(ARGV[0]).map(&:strip)

ing_and_all = input.map do |line|
  chunks = line.split(' (contains')
  ingredients = chunks[0].split(/ /).map(&:strip)

  ingredients.each do |ingredient|
    all_ingredients[ingredient] += 1
  end

  allergens = chunks[1].chop.split(/,/)
                       .map(&:strip)
                       .reject(&:empty?)

  [ingredients, allergens]
end

a_to_i = Hash.new { Hash.new { 0 } }

allergen_rows = Hash.new { 0 }

ing_and_all.each do |ingredients, allergens|
  allergens.each do |allergen|
    allergen_rows[allergen] += 1
    a2i = a_to_i[allergen]

    ingredients.each do |ingredient|
      a2i[ingredient] += 1
    end

    a_to_i[allergen] = a2i
  end
end

def print_map(name, m)
  puts "Map: #{name}"
  m.each do |k, v|
    puts " #{k} = #{v}"
  end

  puts "\n\n"
end

print_map("a_to_i", a_to_i)
print_map("allergen_rows", allergen_rows)

allergens_found = {}

until a_to_i.empty?
  allergen_rows.each do |allergen, row_count|
    ingredients = a_to_i[allergen]
    ingredients = ingredients.reject { |_, count| count != row_count }

    if ingredients.length == 1
      allergens_found[allergen] = ingredients.keys.first
      a_to_i.delete(allergen)
      a_to_i.each do |al, ing|
        ing = ing.reject { |ing1| ing1 == ingredients.keys.first }
        a_to_i[al] = ing
      end
    elsif ingredients.empty?
      # pass
    else
      a_to_i[allergen] = ingredients
    end
  end
end

print_map("a_to_i", a_to_i)
print_map("allergens_found", allergens_found)

allergens_found.values.each do |ingredient|
  all_ingredients.delete(ingredient)
end

puts "all_ingredients: #{all_ingredients}"
ing_count = all_ingredients.inject(0) do |acc, v|
  acc + v[1]
end

puts "ing_count: #{ing_count}"

res = allergens_found.sort_by {|key, value| key}.map {|arr| arr[1]}.join(',')
puts "res: #{res}"
