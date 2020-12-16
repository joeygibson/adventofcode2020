#!/usr/bin/env ruby

require 'set'

if ARGV.length != 1
  puts 'Usage: day16.rb <input file>'
  exit(1)
end

input = File.readlines(ARGV[0]).map(&:strip)

fields = {}
valid_ranges = Set.new

input.take(input.index { |line| line == "" }).map do |line|
  matches = line.match(/^([^:]+):/)
  field_name = if matches
                 matches[0]
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

my_ticket = input[input.index { |line| line == 'your ticket:' } + 1]

nearby_tickets = input.drop(input.index { |line| line == 'nearby tickets:' } + 1)
                      .map { |line| line.split(',').map(&:to_i) }

rejected_numbers = []
nearby_tickets.each do |ticket|
  ticket.each do |value|
    unless valid_ranges.any? { |range| range.member?(value) }
      rejected_numbers << value
    end
  end
end

puts "scanning error rate: #{rejected_numbers.sum}"

