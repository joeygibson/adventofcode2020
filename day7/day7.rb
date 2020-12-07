#!/usr/bin/env ruby

require 'set'

class BagType
  attr_reader :name
  attr_accessor :contents, :containers

  def to_s
    @name
  end

  def initialize(name)
    @name = name
    @contents = []
    @containers = []
  end

  def self.get_or_create(rule, defined_types)
    name = rule.match(/^(.+) bags contain/)[1]
    contained_type_names = rule.scan(/(\d+) ([\w\s]+) bags?/)

    bag_type = if defined_types.key?(name)
                 defined_types[name]
               else
                 BagType.new(name)
               end

    defined_types[name] = bag_type

    if bag_type.contents.empty?
      contained_type_names.each do |type_name_arr|
        bag_count = type_name_arr[0].to_i
        type_name = type_name_arr[1]
        contained_bag_type = defined_types[type_name]

        if contained_bag_type.nil?
          contained_bag_type = BagType.new(type_name)
          defined_types[type_name] = contained_bag_type
        end

        contained_bag_type.containers << bag_type if contained_bag_type.containers.select { |item| item.name == self.name }

        (1..bag_count).each do
          bag_type.contents << contained_bag_type
        end
      end
    end

    bag_type
  end
end

bag_types = {}

File.readlines('input.txt').map do |rule|
  BagType.get_or_create(rule, bag_types)
end

def walk_up(top_level, bag_type)
  bag_type.containers.each do |container|
    top_level << container
    walk_up(top_level, container)
  end
end

def count_bags(bag_types)
  bag_types.inject(0) do |count, bag_type|
    count += 1 + count_bags(bag_type.contents)
    count
  end
end

gold = bag_types['shiny gold']
top_level = Set.new
walk_up(top_level, gold)
total_bags = count_bags(gold.contents)

puts "bags types containing 'shiny gold' bags: #{top_level.length}"
puts "total bags contained by a 'shiny gold' bag: #{total_bags}"
