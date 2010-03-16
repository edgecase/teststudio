# REQUIRED SOFTWARE FOR THE TEST DRIVEN DESIGN STUDIO
#
# Installing using Rake 
# ---------------------
#
# This file is setup as a rake file that should be runnable on any
# ruby system where rake is installed.  To install the required gems
# for the test studio just type:
#
#    rake -f required_software.rake install
# 
# To get help information, type:
#
#    rake -f required_software.rake
#
# Installing by Hand
# ------------------
#
# If you don't have the rake command available, you may install the
# following gems by hand using the "gem install" command.
#
# For example, to install the 'cucumber' gem, just type the following
# at the command line:
#
#    gem install cucumber
#
# OK, here are the required gems:
#
REQUIRED_GEMS = [
  'cucumber',
  'cucumber-rails',
  'diff-lcs',
  'flexmock',
  'heckle',
  'context',
  'nokogiri',
  'rcov',
  'rspec',
  'rspec-rails',
  'Selenium',
  'RedCloth',
  'term-ansicolor',
  'treetop',
  'shoulda',
  'webrat',
  'factory_girl',
  'faker',
]

# Using Rvm (optional)
# --------------------
#
# RVM is a Ruby version manager that allows you to have multiple
# version of Ruby installed on your system at one time, making it easy
# to switch between different Ruby versions.  It also allows you to
# have multiple gem repositories (known as "gemsets" in RVM lingo).
#
# If you wish to isolate the gems required for the test studio from
# your normally installed gems, then setup rvm with the instructions
# at http://rvm.beginrescueend.com.
#
# Once RVM is setup with alternate version of Ruby, you can create a
# studio gemset that will contain only the gems used in the studio.
# Here are the commands we used.
#
# rvm use 1.8.7               # (or a different version if you prefer)
# rvm gemset create studio
# rvm gemset use studio
# gem install rake            # You will need rake in the gemset to
#                             # install the rest of the gems.
#

# ====================================================================
# From this point on are the rake commands used to install the gems
# listed above.
# ====================================================================

RAILS_GEMS = [
  'rails',
  'sqlite3-ruby',
]

module Install
  def self.gems(*gem_list)
    puts
    gem_list.each do |gem|
      puts
      puts "** Installing #{gem} **"
      sh "gem install #{gem} --no-ri --no-rdoc"
    end
  end
end

task :default => :help

task :help do
  puts
  puts "The following rake targets are available:"
  puts
  verbose(false) do
    sh "rake -s -f #{Rake.application.rakefile} -T"
  end
end

desc "Install just the required gems"
task :install => "install:required"

namespace "install" do
  desc "Install rails in addition to the required gems"
  task :all => [:rails, :required]

  task :rails do
    Install.gems(*RAILS_GEMS)
  end
  
  task :required do
    Install.gems(*REQUIRED_GEMS)
  end

  desc "Install the watir gem"
  task :watir do
    Install.gems("watir")
  end

  desc "Install the firewatir gem"
  task :firewatir do
    Install.gems("firewatir")
    puts "See http://wiki.openqa.org/display/WTR/FireWatir+Installation"
    puts "for instructions on installing the JSSH required for firewatir."
  end

  desc "Install the safariwatir gem"
  task :safariwatir do
    Install.gems("safariwatir")
  end
end
