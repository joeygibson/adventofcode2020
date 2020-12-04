#!/usr/bin/env ruby

passports = File.read('input.txt').split(/^\s*$/).map do |line|
  chunks = line.strip.split(/\s+/)

  passport = {}

  chunks.each do |pair|
    key, value = pair.split(/:/)
    passport[key] = value.strip
  end

  passport
end

def basic_valid?(passport)
  passport.length == 8 || (passport.length == 7 && passport['cid'].nil?)
end

def really_valid?(passport)
  return false unless basic_valid?(passport)

  fields = passport.map do |key, value|
    case key
    when 'byr'
      value.to_i >= 1920 && value.to_i <= 2002
    when 'iyr'
      value.to_i >= 2010 && value.to_i <= 2020
    when 'eyr'
      value.to_i >= 2020 && value.to_i <= 2030
    when 'hgt'
      value =~ /(\d+)(cm|in)/
      case Regexp.last_match(2)
      when 'cm'
        Regexp.last_match(1).to_i >= 150 && Regexp.last_match(1).to_i <= 193
      when 'in'
        Regexp.last_match(1).to_i >= 59 && Regexp.last_match(1).to_i <= 76
      else
        false
      end
    when 'hcl'
      !(value =~ /^#[a-f0-9]{6}/).nil?
    when 'ecl'
      %w[amb blu brn gry grn hzl oth].count(value) == 1
    when 'pid'
      !(value =~ /^\d{9}$/).nil?
    else
      true
    end
  end

  fields.all? { |val| !!val }
end

valid_passports = passports.select { |passport| basic_valid?(passport) }

puts "Passports: #{passports.length}, Valid passports: #{valid_passports.length}"

really_valid_passports = passports.select { |passport| really_valid?(passport) }

puts "Passports: #{passports.length}, Really Valid passports: #{really_valid_passports.length}"
