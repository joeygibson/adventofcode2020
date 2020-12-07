#!/usr/bin/env ruby

require 'set'

class BagType
  attr_reader :name
  attr_accessor :contents, :containers

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
        type_name = type_name_arr[1]
        contained_bag_type = defined_types[type_name]

        if contained_bag_type.nil?
          contained_bag_type = BagType.new(type_name)
          defined_types[type_name] = contained_bag_type
        end

        contained_bag_type.containers << bag_type if contained_bag_type.containers.select { |item| item.name == self.name }
        bag_type.contents << contained_bag_type
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
    top_level << container.name
    walk_up(top_level, container)
  end
end

gold = bag_types['shiny gold']
top_level = Set.new
walk_up(top_level, gold)

puts top_level.length
puts top_level
