#!/usr/bin/env ruby

require 'set'

program = File.readlines('input.txt').map(&:strip).reject(&:empty?)

instruction_cache = Set.new

acc = 0
ip = 0
old_ip = 0
nop_cache = []
jmp_cache = []

loop do
  break if ip >= program.length

  line = program[ip]

  if instruction_cache.include?(ip)
    puts "infinite loop at instruction! acc = #{acc}"
    puts "\tnop_cache: #{nop_cache.reverse.take(10)}"
    puts "\tjmp_cache: #{jmp_cache.reverse.take(10)}"
    break
  else
    instruction_cache << ip
  end

  op, sign, arg = line.match(/^(\w+)\s+([+\-])(\d+)$/).captures
  case op
  when 'nop'
    # do nothing
    nop_cache << ip
  when 'acc'
    if sign == '+'
      acc += arg.to_i
    else
      acc -= arg.to_i
    end
  when 'jmp'
    jmp_cache << ip
    old_ip = ip

    if sign == '+'
      ip += arg.to_i
    else
      ip -= arg.to_i
    end
    next
  else
    puts "invalid op: #{op}"
  end

  old_ip = ip
  ip += 1
end

puts "program terminated; acc = #{acc}"
