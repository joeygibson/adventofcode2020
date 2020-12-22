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

# if player1.length != player2.length
#   puts "wrong deck counts! #{player1.length} != #{player2.length}"
#   exit 2
# end

def combat(player1, player2)
  history = Hash.new { 0 }

  until player1.length.zero? || player2.length.zero?
    state = [player1, player2]

    if !history[state].zero?
      player2 = []
      break
    else
      history[state] = 1
    end

    card1 = player1[0]
    card2 = player2[0]

    player1 = player1.drop(1)
    player2 = player2.drop(1)

    winner = if player1.length >= card1 && player2.length >= card2
               # recurse!
               winner, = combat(player1.clone.take(card1), player2.clone.take(card2))
               winner
             elsif card1 > card2
               :player1
             else
               :player2
             end
    if winner == :player1
      player1 << card1
      player1 << card2
    else
      player2 << card2
      player2 << card1
    end
  end

  if player1.length.zero?
    [:player2, player2]
  else
    [:player1, player1]
  end
end

winner, deck = combat(player1, player2)

puts "winner: #{winner} deck: #{deck}"
res = deck.reverse.each_with_index.inject(0) do |acc, (num, idx)|
  acc + num * (idx + 1)
end

puts "res: #{res}"
