#!/usr/bin/env ruby

require 'set'

def process_group_any(group)
  consolidated_answers = Set.new

  group.split(/\n/).each do |answers|
    answers.split(//) do |letter|
      consolidated_answers << letter
    end
  end

  consolidated_answers.length
end

group_answers = File.read('input.txt').split(/\n\n/).map do |group|
  process_group_any(group)
end

total = group_answers.inject(0) do |sum, answers|
  sum + answers
end

puts "Total: #{total}"
