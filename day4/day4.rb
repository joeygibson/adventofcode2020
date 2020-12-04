#!/usr/bin/env ruby

passports = File.read('input.txt').split(/^\s*$/).map do |line|
  chunks = line.strip.split(/\s+/)

  passport = {}

  chunks.each do |pair|
    key, value = pair.split(/:/)
    passport[key] = value
  end

  passport
end

def valid?(passport)
  passport.length == 8 || (passport.length == 7 && passport['cid'].nil?)
end

valid_passports = passports.select { |passport| valid?(passport) }

puts "Passports: #{passports.length}, Valid passports: #{valid_passports.length}"
