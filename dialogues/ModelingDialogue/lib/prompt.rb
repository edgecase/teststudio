#!/usr/bin/env ruby
# -*- ruby -*-

require 'ansi_colors'

RESET = AnsiColors.new(:white, :black, :reset)
REV = AnsiColors.new(:reverse)
NO_REV = AnsiColors.new(:reset)

ACTOR_COLORS = [
  :green, :yellow, :cyan, :white, :red, :blue
].map { |c|
  AnsiColors.new(c, :black, :bright)
}
INSTRUCTION_COLORS = AnsiColors.new(:reset) + AnsiColors.new(:magenta, :black)

ACTORS = {}

def calibrate
  100.downto(1) do |i| puts i end
  print "Enter the top number on the screen: "
  $lines = gets.to_i
end

def clear
  print "\e[2J"
end

def page
  40.times { puts }
end

def pause
  STDIN.gets.chomp
end

def prompt(fn)
  clear
  puts fn
  pause
end

def locate(re, paras)
  (0..paras.size).each do |i|
    return i if re =~ paras[i]
  end
  nil
end

class String
  def blank?
    self =~ /^\s*$/
  end
end

def window(index)
  index = 0 if index < 0
  start = index - 10
  start = 0 if start < 0
  return start, index
end

def line_out(s, limit)
  lines = s.split("\n")
  while !lines.empty?
    puts lines.shift
    limit -= 1
    return 0 if limit <= 0
  end
  if limit > 0
    puts
    limit -= 1
  end
  limit
end

files = ARGV.to_a.dup
ARGV.clear

if files.first =~ /^\d+$/
  $lines = files.shift.to_i
else
  calibrate
end

puts "#$lines lines"
paragraphs = []
files.each do |fn|
  open(fn) do |ins|
    begin
      p = ""
      while line = ins.gets
        next if line =~ /^#/
        break if line.blank?
        p << line
      end
      paragraphs << p if p.size > 0
    end while line
  end
end

print RESET
clear
start = 0
index = 0
loop do
  clear
  limit = $lines
  i = index
  while limit > 0 && i < paragraphs.size
    out = paragraphs[i]
    next if out.nil?
    case out
    when /^([A-Za-z]+):/
      actor = $1
      color = ACTORS[actor]
      if color.nil?
        color = ACTORS[actor] = ACTOR_COLORS.shift
      end
    else
      color = INSTRUCTION_COLORS
    end
    out = out.gsub(/\[/, "#{INSTRUCTION_COLORS}[")
    out = out.gsub(/\]/, "]#{color}")
    if out =~ /^[a-zA-Z]+:/
      out = out.sub(/^/, REV + color)
      out = out.sub(/:/, ":" + NO_REV + color)
    else
      out = out.sub(/^/, color) 
    end
    limit = line_out(out, limit)
    i += 1
  end
  cmd = pause
  case cmd
  when 'c'
    clear
    start = index
  when '+'
    clear
    start, index = window(index)
  when 'b', '-'
    page
    start, index = window(index-1)
  when 'x', 'q'
    break
  when 'e'
    page
    start, index = window(paragraphs.size-1)
  when /^([ivxlmc]+)$/
    act_number = $1.upcase
    page
    start = index = locate(/^Act\s+#{act_number}\s*$/, paragraphs) || index
  when /^\d+$/
    page
    start, index = window(cmd.to_i)
  when '?'
    puts INSTRUCTION_COLORS + index.to_s
  when ''
    index = [paragraphs.size-1, index + 1].min
    start = index
  else
    puts "?"
  end
end

print RESET
