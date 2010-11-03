desc "Run all the tests for continuous integration"
task :cruise => ["spec", "cucumber"]
