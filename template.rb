#!/usr/bin/env ruby

if ARGV.length != 1
  puts 'Usage: day167rb <input file>'
  exit(1)
end

input = File.readlines(ARGV[0]).map(&:strip)

