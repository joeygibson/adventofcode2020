#!/usr/bin/env ruby

require 'set'

program = File.readlines('input.txt').map(&:strip).reject(&:empty?)

instruction_cache = Set.new

acc = 0
ip = 0

loop do
  line = program[ip]

  if instruction_cache.include?(ip)
    puts "infinite loop! acc = #{acc}"
    break
  else
    instruction_cache << ip
  end

  op, sign, arg = line.match(/^(\w+)\s+([+\-])(\d+)$/).captures
  case op
  when 'nop'
    # do nothing
  when 'acc'
    if sign == '+'
      acc += arg.to_i
    else
      acc -= arg.to_i
    end
  when 'jmp'
    if sign == '+'
      ip += arg.to_i
    else
      ip -= arg.to_i
    end
    next
  else
    puts "invalid op: #{op}"
  end

  ip += 1
end