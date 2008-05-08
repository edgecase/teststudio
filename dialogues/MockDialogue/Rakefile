#!/usr/bin/env ruby
# -*- ruby -*-

task :default => :test_success

task :test do
  ruby 'test_units.rb'
end

desc "Display test success"
task :test_success do
  ruby 'test_success.rb'
end

desc "Run the teleprompter"
task :prompt do
  ruby "prompt.rb MockDialogue_Act1.txt MockDialogue_Act2.txt MockDialogue_Act3.txt"
end
