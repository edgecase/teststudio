# REQUIRED SOFTWARE FOR THE TEST DRIVEN DESIGN STUDIO
#
# This file may be run as a shell script if you are running on Linux
# or Mac OS.  Otherwise you can manually install each of the gems
# listed below.
#
# USING RVM
#
# If you want to isolate this installation, use rvm (see
# http://rvm.beginrescueend.com/ for details).
#
# We used the following rvm commands:
#
# rvm use 1.8.7               # (or a different version if you prefer)
# rvm gemset create studio
# rvm gemset use studio
#

# INSTALL RAILS
#
# Install the latest version of rails.  You may skip this if you
# already have rails installed.
#
gem install rails --no-rdoc --no-ri
gem install sqlite3-ruby --no-rdoc --no-ri

# INSTALL THE REQUIRED GEMS
#
# If you want locally generated documentation for each of the gems,
# remove the --no-rdoc --no-ri flags.
#
gem install cucumber  --no-rdoc --no-ri
gem install cucumber-rails --no-rdoc --no-ri
gem install diff-lcs --no-rdoc --no-ri
gem install flexmock --no-rdoc --no-ri
gem install heckle --no-rdoc --no-ri
gem install context --no-rdoc --no-ri
gem install nokogiri --no-rdoc --no-ri
gem install rcov --no-rdoc --no-ri
gem install rspec --no-rdoc --no-ri
gem install rspec-rails --no-rdoc --no-ri
gem install Selenium --no-rdoc --no-ri
gem install RedCloth  --no-rdoc --no-ri # NOTE: on Windows you may have to include --platform=x86-mswin32-60
gem install term-ansicolor --no-rdoc --no-ri
gem install treetop --no-rdoc --no-ri
gem install shoulda --no-rdoc --no-ri
gem install webrat --no-rdoc --no-ri
gem install factory_girl --no-rdoc --no-ri
gem install faker --no-rdoc --no-ri

# OPTIONAL SOFTWARE
#
# We will talk briefly about watir, but none of the labs depend on it.
# If you wish to install it, you can use the following commands.
#
# NOTE: firewatir has additional installation steps to install jssh.
# See http://wiki.openqa.org/display/WTR/FireWatir+Installation for
# details.

# gem install watir  --no-rdoc --no-ri
# gem install safariwatir --no-rdoc --no-ri
# gem install firewatir  --no-rdoc --no-ri  # NOTE: There are extra steps with firewatir
