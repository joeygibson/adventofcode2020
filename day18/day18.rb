#!/usr/bin/env ruby

require 'strscan'

if ARGV.length != 1
  puts "Usage: #{__FILE__} <input file>"
  exit(1)
end

class Expr
  def evaluate
    raise 'subclass responsibility'
  end
end

class Int < Expr
  def initialize(value)
    @value = value
  end

  def evaluate
    @value
  end

  def to_s
    @value.to_s
  end
end

class BinaryExpr < Expr
  def initialize(left, right)
    @left = left
    @right = right
  end
end

class Add < BinaryExpr
  def evaluate
    @left.evaluate + @right.evaluate
  end

  def to_s
    "#{@left.to_s} + #{@right.to_s}"
  end
end

class Mul < BinaryExpr
  def evaluate
    @left.evaluate * @right.evaluate
  end

  def to_s
    "#{@left.to_s} * #{@right.to_s}"
  end
end

class Parser
  def initialize(str)
    @buffer = StringScanner.new(str.strip)
    @length = str.length
    @done = false
  end

  def drop_whitespace
    @buffer.scan(/\s+/) if @buffer.peek(1) =~ /\s/
  end

  def combine_with_op(left, op, right)
    if op == '+'
      Add.new(left, right)
    else
      Mul.new(left, right)
    end
  end

  def parse()
    left = nil
    op = nil

    until @buffer.empty?
      drop_whitespace

      case @buffer.peek(1)
      when /\d/
        tmp = Int.new(@buffer.scan(/\d+/).to_i)
        left = if left.nil?
                 tmp
               else
                 res = combine_with_op(left, op, tmp)
                 op = nil
                 res
               end
      when '+'
        op = @buffer.getch
      when '*'
        op = @buffer.getch
      when /\(/
        @buffer.getch
        if left == nil
          left = parse
        else
          right = parse
        end

        if op != nil && left != nil && right != nil
          left = combine_with_op(left, op, right)
          op = nil
          right = nil
        end
      when /\)/
        @buffer.getch
        if right == nil
          return left
        else
          return combine_with_op(left, op, right)
        end
      else
        puts "invalid character: #{@buffer.peek(1)}"
      end
    end

    if op != nil && left != nil && right != nil
      combine_with_op(left, op, right)
    elsif left != nil
      left
    else
      right
    end
  end
end

input = File.readlines(ARGV[0]).map(&:strip).reject(&:empty?)

results = input.map do |line|
  p = Parser.new(line)
  e = p.parse
  res = e.evaluate

  puts "#{line} = #{res}"

  res
end

total = results.sum

puts "total: #{total}"


