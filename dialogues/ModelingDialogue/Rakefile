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

task :prompt do
  ruby "-Ilib lib/prompt.rb Act1.txt Act2.txt Act3.txt"
end
