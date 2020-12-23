#!/usr/bin/env ruby

class Node
  attr_accessor :value, :next_node

  def initialize(value)
    @value = value
    @next_node = nil
  end

  # def <=>(other)
  #   @value <=> other.value
  # end

  def ==(other)
    @value == other.value
  end

  def to_s
    @value.to_s
  end
end

def to_linked_list(arr)
  all_nodes = {}

  head = Node.new(arr[0])
  prev = head

  all_nodes[arr[0]] = head

  (1...arr.length).each do |idx|
    next_node = Node.new(arr[idx])
    all_nodes[arr[idx]] = next_node
    prev.next_node = next_node
    prev = next_node
  end

  prev.next_node = head
  [head, all_nodes]
end

def print_10(node)
  puts '-' * 80
  puts node.value.to_s

  10.times do |nn|
    node = node.next_node
    puts node.value.to_s
  end
end

if ARGV.length != 2
  puts "Usage: #{__FILE__} <input file> <number of moves>"
  exit(1)
end

input = File.readlines(ARGV[0]).map(&:strip)[0].split(//).map(&:to_i)

number_of_moves = ARGV[1].to_i

max_value = input.max
input += (max_value + 1..1_000_000).to_a

min_value = input.min
max_value = input.max

orig_head, all_nodes = to_linked_list(input)
head = orig_head

total_moves = 0
number_of_moves.times do |move|
  total_moves += 1
  puts "Move: #{move}" if (move % 100_000).zero?

  to_move = [head.next_node, head.next_node.next_node, head.next_node.next_node.next_node]
  next_node = head.next_node.next_node.next_node.next_node

  head.next_node = next_node

  to_move.each do |node|
    all_nodes.delete(node.value)
  end

  dest = if head.value - 1 < min_value
           max_value
         else
           head.value - 1
         end

  while to_move.include?(Node.new(dest))
    dest -= 1
    dest = max_value if dest < min_value
  end

  # puts "dest: #{dest}"
  dest_node = all_nodes[dest]
  after = dest_node.next_node
  dest_node.next_node = to_move[0]
  to_move[2].next_node = after

  to_move.each do |node|
    all_nodes[node.value] = node
  end

  head = next_node
end

puts "total: #{total_moves}"
one = all_nodes[1]

n = one.next_node.value
n1 = one.next_node.next_node.value

puts "one: #{one}"
puts "n: #{n}, n1: #{n1}"
puts "res: #{n * n1}"
