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

files = ARGV.to_a.dup
ARGV.clear
paragraphs = []
files.each do |fn|
  open(fn) do |ins|
    begin
      p = ""
      while line = ins.gets
        break if line.blank?
        p << line
      end
      paragraphs << p
    end while line
  end
end

print RESET
clear
start = 0
index = 0
loop do
  (start..index).each do |i|
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
    puts out
    puts if start != index
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
