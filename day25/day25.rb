#!/usr/bin/env ruby

if ARGV.length != 1
  puts "Usage: #{__FILE__} <input file>"
  exit(1)
end

DIVISOR = 20201227
SUBJECT_NUMBER = 7

def transform(subject, loop_size)
  value = 1
  loop_size.times do
    value *= subject
    value = value % DIVISOR
  end

  value
end

def discover_loop_size(public_key)
  val = 1
  iteration = 1

  loop do
    val *= SUBJECT_NUMBER
    val = val % DIVISOR

    break if val == public_key

    iteration += 1
  end

  iteration
end

input = File.readlines(ARGV[0]).map(&:strip).reject(&:empty?)

card_public_key = input[0].to_i
door_public_key = input[1].to_i

card_loop_size = discover_loop_size(card_public_key)
door_loop_size = discover_loop_size(door_public_key)

puts "card: #{card_loop_size}"
puts "door: #{door_loop_size}"

door_encryption_key = transform(door_public_key, card_loop_size)
card_encryption_key = transform(card_public_key, door_loop_size)

puts "door enc: #{door_encryption_key}"
puts "card enc: #{card_encryption_key}"

