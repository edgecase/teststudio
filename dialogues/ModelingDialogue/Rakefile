#!/usr/bin/env ruby
# -*- ruby -*-

task :default => :test_success

task :test do
  ruby 'test_units.rb'
end

task :test_success do
  ruby 'test_success.rb'
end

task :prompt do
  ruby "prompt.rb Act*.txt"
end

task :pack do
  sh 'tar zcvf MockDialogue_key.tgz MockDialogue.key'
end

directory 'new_keynote'

task :unpack => 'new_keynote' do
  Dir.chdir("new_keynote") do
    sh 'tar zxvf ../MockDialogue_key.tgz'
  end
end
