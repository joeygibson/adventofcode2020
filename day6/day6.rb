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

def process_group_all(group)
  consolidated_answers = Hash.new(0)

  group.split(/\n/).each do |answers|
    answers.split(//) do |letter|
      consolidated_answers[letter] += 1
    end
  end

  consolidated_answers.select { |key, value|
    value == group.split(/\n/).length
  }.length
end

input = File.read('input.txt').split(/\n\n/)

group_answers_any = input.map do |group|
  process_group_any(group)
end

group_answers_all = input.map do |group|
  process_group_all(group)
end

total_any = group_answers_any.inject(0) do |sum, answers|
  sum + answers
end

total_all = group_answers_all.inject(0) do |sum, answers|
  sum + answers
end

puts "Total (any): #{total_any}"
puts "Total (all): #{total_all}"
