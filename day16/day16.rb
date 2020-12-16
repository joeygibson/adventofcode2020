#!/usr/bin/env ruby
# portions of part 2 solutions shamelessly borrowed from
# https://github.com/j-clark/adventofcode/commit/29225aa85fe56909fa2cdd19fb30c68537f79d46

require 'matrix'
require 'set'

if ARGV.length != 1
  puts 'Usage: day16.rb <input file>'
  exit(1)
end

input = File.readlines(ARGV[0]).map(&:strip)

fields = {}
valid_ranges = Set.new

input.take(input.index { |line| line == '' }).map do |line|
  matches = line.match(/^([^:]+):/)
  field_name = if matches
                 matches[0][0..-2]
               else
                 'INVALID'
               end
  ranges = line.scan(/(\d+)-(\d+)/).map do |match|
    s = match[0].to_i
    e = match[1].to_i

    r = (s..e)
    valid_ranges << r

    r
  end

  fields[field_name] = ranges
end

my_ticket = input[input.index { |line| line == 'your ticket:' } + 1].split(',').map(&:to_i)

nearby_tickets = input.drop(input.index { |line| line == 'nearby tickets:' } + 1)
                      .map { |line| line.split(',').map(&:to_i) }
                      .reject(&:empty?)

valid_tickets = nearby_tickets.select do |ticket|
  ticket.all? do |value|
    valid_ranges.any? { |range| range.member?(value) }
  end
end

# m = Matrix.rows(valid_tickets)

# fields_matched = Hash.new {[]}
#
# end_range = valid_tickets[0].length - 1
# column_attributes = (0..end_range).map do |idx|
#   col = m.column(idx)
#
#   matches = fields.select do |name, ranges|
#     col.all? do |value|
#       ranges.any? do |range|
#         range.member?(value)
#       end
#     end
#   end
#
#   matches.each do |match|
#     puts "match: #{match[0]}"
#     cols = fields_matched[match[0]]
#     cols << idx
#     fields_matched[match[0]] = cols
#   end
#
#   matches
# end

rules_to_positions = {}
fields.each do |name, ranges|
  positions = (0..(valid_tickets.length - 1)).to_a.select do |pos|
    valid_tickets.all? do |ticket|
      ranges.any? do |range|
        range.member?(ticket[pos])
      end
    end
  end

  rules_to_positions[name] = positions
end

until rules_to_positions.values.all?(&:one?) do
  pos_to_remove = rules_to_positions.select { |_, ps| ps.one? }.map(&:last).flatten
  names_to_remove_from = rules_to_positions.reject { |_, ps| ps.one? }.map(&:first).flatten

  pos_to_remove.each do |pos|
    names_to_remove_from.each do |name|
      rules_to_positions[name].delete(pos)
    end
  end
end

result = rules_to_positions.transform_values(&:first)
                           .select { |k, v| k =~ /depart/ }
                           .map(&:last)
                           .map { |i| my_ticket[i] }
                           .reduce(&:*)

puts "result: #{result}"

