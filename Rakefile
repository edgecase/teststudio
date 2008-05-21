#!/usr/bin/env ruby
# -*- ruby -*-

require 'rake/clean'

CLOBBER.include("pkg")

LABS = FileList['labs/*'].select { |fn| fn.pathmap("%f") =~ /^\d\d_/ }
DAILIES = {
  "pkg/day01" => LABS.select { |fn|
    labno = fn.pathmap("%n").split('_').first.to_i
    labno < 5
  },
  "pkg/day02" => LABS.select { |fn|
    labno = fn.pathmap("%n").split('_').first.to_i
    labno >= 5  && labno <= 6
  },
}

TAR_FILES = LABS.pathmap("pkg/%f.tgz")
ZIP_FILES = LABS.pathmap("pkg/%f.zip")

PACKAGE_FILES = TAR_FILES + ZIP_FILES +
  DAILIES.keys.map { |fn| "#{fn}.tgz" } +
  DAILIES.keys.map { |fn| "#{fn}.zip" }

task :default => :package

desc "Create the package files for the labs"
task :package => PACKAGE_FILES

directory "pkg"

TAR_FILES.each do |tarfn|
  labfn = tarfn.pathmap("labs/%n")
  file tarfn => ["pkg", labfn] do |t|
    sh "tar zcvf #{tarfn} #{labfn}"
  end
end

ZIP_FILES.each do |zipfn|
  labfn = zipfn.pathmap("labs/%n")
  file zipfn => ["pkg", labfn] do |t|
    chdir("labs") do 
      sh "zip -r ../#{zipfn} #{labfn.pathmap("%f")}"
    end
  end
end

DAILIES.each do |key, labs|
  tarfn = "#{key}.tgz"
  file tarfn => labs do
    sh "tar zcvf #{tarfn} #{labs}"
  end
end

DAILIES.each do |key, labs|
  zipfn = "#{key}.zip"
  file zipfn => labs do
    labs = labs.map { |fn| fn.pathmap("%f") }
    Dir.chdir("labs") do
      sh "zip -r ../pkg/#{zipfn.pathmap('%f')} #{labs}"
    end
  end
end
