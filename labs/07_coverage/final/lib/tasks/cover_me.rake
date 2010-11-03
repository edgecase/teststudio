namespace :cover_me do
  desc "Format the coverage report"
  task :report do
    require 'cover_me'
    CoverMe.complete!
  end
end

desc "Generate Coverage Report"
task :coverage => [:spec, 'cover_me:report']
