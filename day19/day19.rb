#!/usr/bin/env ruby

if ARGV.length != 1
  puts "Usage: #{__FILE__} <input file>"
  exit(1)
end

def all_mapped(rules)
  rules.values.none? { |rule| rule =~ /\d/ }
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

mapped_count = 0
unmapped = []

until all_mapped(rules)
  mapped = rules.reject { |_, v| v =~ /\d/ }
  unmapped1 = rules.select { |_, v| v =~ /\d/ }

  if unmapped == unmapped1
    # puts "unmapped: #{unmapped}"
    # puts "unmapped1: #{unmapped1}"
    break
  end
  unmapped = unmapped1

  len = mapped.length
  if len != mapped_count
    puts "mapped rules: #{len}"
    mapped_count = len
  end

  mapped.each do |k, v|
    references = rules.select do |_, rv|
      rv =~ /\b#{k}\b/
    end

    next if references.empty?

    references.each do |rk, rv|
      if rk == "8" || rk == "11" || rk == k
        puts "cycle"
      end
      value = if v =~ /\|/
                rv.gsub(/\b#{k}\b/, "(#{v})")
              else
                rv.gsub(/\b#{k}\b/, v)
              end

      rules[rk] = value
    end
  end
end

puts "rules mapped: #{rules.length}"
puts "rules unmapped: #{unmapped.length}"
puts "unmapped: #{unmapped}"

# handle recursive rules
rule = rules['8']
rule = rule.sub('8', '').prepend('(?<zzz>') << ')\g<zzz>'
rules['8'] = rule

rule = rules['11']
rule = rule.sub('11', ')\g<xxx>\g<yyy>(?<yyy>').prepend('(?<xxx>') << ')'
rules['11'] = rule

rule = "#{rules['8']} #{rules['11']}"
rules['0'] = rule

rules.each do |k, v|
  value = v.gsub(' ', '')
  rules[k] = value
end

# puts "rules: #{rules}"

rule = rules['0']

matches = messages.select do |message|
  message =~ /^#{rule}$/
end

# puts "matches: #{matches}"
puts "matches: #{matches.length}"
