#!/usr/bin/env ruby

if ARGV.length != 1
  puts "Usage: #{__FILE__} <input file>"
  exit(1)
end

def all_mapped(rules)
  rules.values.none? { |rule| rule =~ /\d/ }
end

def is_mapped(rule)
  rule !~ /\d/
end

input = File.readlines(ARGV[0]).map(&:strip)

rule_descriptions = input.take_while { |line| !line.empty? }
puts "descriptions: #{rule_descriptions.length}"

messages = input.drop_while { |line| !line.empty? }.drop(1)
puts "messages: #{messages.length}"

rules = {}

rule_descriptions.each do |desc|
  chunks = desc.split(':').map(&:strip)
  rules[chunks[0]] = chunks[1].gsub('"', '')
end

puts "rules built: #{rules.length}"

unmapped_count = 0

until all_mapped(rules)
  unmapped = rules.select { |k, v| v =~ /\d/ }

  len = unmapped.length
  if len != unmapped_count
    puts "unmapped rules: #{len}"
    unmapped_count = len
  end

  unmapped.each do |k, v|
    value = v.clone
    numbers = v.scan /\d/
    numbers.each do |num|
      ref_rule = rules[num]
      next unless is_mapped(ref_rule)

      value = if ref_rule =~ /\|/
                value.gsub(num, "(#{ref_rule})")
              else
                value.gsub(num, ref_rule)
              end
    end

    if value != v
      puts "MAPPED"
      rules[k] = value
    end
  end
end

puts "rules mapped: #{rules.length}"

rules.each do |k, v|
  value = v.gsub(' ', '')
  rules[k] = value
end

puts "rules: #{rules}"

rule = rules['0']

matches = messages.select do |message|
  message =~ /^#{rule}$/
end

puts "matches: #{matches}"

puts "matches: #{matches.length}"

