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
#    gem install cucumber --version=0.6.3
#
# OK, here are the required gems:
#
REDCLOTH_OPTS = Rake.application.windows? ? '-platform=x86-mswin32-60' : nil

REQUIRED_GEMS = [
  ['cucumber', '0.6.3'],
  ['cucumber-rails', '0.3.0'],
  ['diff-lcs', '1.1.2'],
  ['flexmock', '0.8.6'],
  ['heckle', '1.4.3'],
  ['context', '0.0.16'],
  ['nokogiri', '1.4.1'],
  ['rcov', '0.9.8'],
  ['rspec', '1.3.0'],
  ['rspec-rails', '1.3.2'],
  ['Selenium', '1.1.14'],
  ['selenium-rails', '0.0.3'],
  ['RedCloth', '4.2.3', REDCLOTH_OPTS],
  ['term-ansicolor', '1.0.5'],
  ['treetop', '1.4.4'],
  ['shoulda', '2.10.3'],
  ['webrat', '0.7.0'],
  ['factory_girl', '1.2.3'],
  ['faker', '0.3.1'],
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
  ['rails', '2.3.5'],
  ['sqlite3-ruby', '1.2.5'],
]

module Install
  def self.gems(*gem_list)
    puts
    gem_list.each do |gem|
      name, version, options = gem
      puts
      puts "** Installing #{name} #{version} **"
      if version
        sh "gem install #{name} --version=#{version} --no-ri --no-rdoc #{options}"
      else
        sh "gem install #{name} --no-ri --no-rdoc"
      end
    end
  end

  def self.describe(*gem_list)
    gem_list.each do |gem|
      name, version = gem
      if version
        puts "gem install #{name} --version=#{version}"
      else
        puts "gem install #{name}"
      end
    end
  end
end

task :default => :help

desc "List the required gems"
task :list do
  Install.describe(*REQUIRED_GEMS)
end

task :list_versions do
  REQUIRED_GEMS.each do |gem|
    name, version = gem
    output = `gem list -l '^#{name}$'`
    if output =~ /\(([\d.]+)\)/
      puts "['#{name}', '#{$1}'],"
    else
      puts "['#{name}', nil],"
    end
  end
end

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
