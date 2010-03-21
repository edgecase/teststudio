begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.test_files = FileList['test/unit/**/*_test.rb', 'test/functional/**/*_test.rb']
    t.libs = ['lib', 'test']
    t.verbose = true     # uncomment to see the executed command
    t.rcov_opts = ['-x', '^/Library,^config,.rvm', '--sort', 'coverage', '--text-report']
  end
rescue LoadError => e 
  puts "rcov not available, please install"  
end
