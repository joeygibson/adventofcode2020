#!/usr/bin/env ruby

if ARGV.length != 1
  puts "Usage: #{__FILE__} <input file>"
  exit(1)
end

input = File.readlines(ARGV[0]).map(&:strip).reject(&:empty?)

player1 = input.drop(1).take_while { |line| line =~ /^\d/ }.map do |line|
  line.to_i
end

player2 = input.drop(player1.length + 2).map do |line|
  line.to_i
end

if player1.length != player2.length
  puts "wrong deck counts! #{player1.length} != #{player2.length}"
  exit 2
end

round = 1

until player1.length.zero? || player2.length.zero?
  puts "round: #{round}" if (round % 100000).zero?
  card1 = player1[0]
  card2 = player2[0]

  player1 = player1.drop(1)
  player2 = player2.drop(1)

  if card1 > card2
    player1 << card1
    player1 << card2
    # puts "player 1 wins"
  else
    player2 << card2
    player2 << card1
    # puts "player 2 wins"
  end

  round += 1
end

winner = if player1.length.zero?
           player2
         else
           player1
         end

res = winner.reverse.each_with_index.inject(0) do |acc, (num, idx)|
  acc + num * (idx + 1)
end

puts "res: #{res}"
