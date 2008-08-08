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
task :prompt, :lines do |t, args|
  acts = FileList['act*.txt']
  ruby "-Ilib lib/prompt.rb #{args.lines} #{acts}"
end
