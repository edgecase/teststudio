#!/usr/bin/env ruby
# -*- ruby -*-

require 'rake/clean'

task :default => :test_success

task :test do
  ruby 'test_units.rb'
end

task :test_success do
  ruby 'test_success.rb'
end

task :prompt, :lines do |t, args|
  ruby "-Ilib lib/prompt.rb #{args.lines} Act1.txt Act2.txt Act3.txt"
end
