PRISTINE_FILES = FileList['log/*']
PRISTINE_FILES.include("db/*.sqlite3")
PRISTINE_FILES.include("coverage", "coverage.data")
Dir['tmp/*'].each do |temp_dir|
  PRISTINE_FILES.include("#{temp_dir}/*")
end

desc "Make the lab pristine"
task :pristine do
  PRISTINE_FILES.each do |fn| rm_r fn rescue nil end
end
