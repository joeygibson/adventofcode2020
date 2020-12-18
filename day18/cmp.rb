#!/usr/bin/env ruby

input1 = File.readlines(ARGV[0]).map(&:strip).reject(&:empty?)
input2 = File.readlines(ARGV[1]).map(&:strip).reject(&:empty?)

good_answers = input2.map do |line|
  matches = line.match(/^\[(\d+)/)
  matches[1]
end

input1.zip(good_answers).each do |line, good_answer|
  chunks = line.split('=').map(&:strip)

  if chunks[1] != good_answer
    puts "#{chunks[0]} | #{chunks[1]} | #{good_answer}"
  end
end
