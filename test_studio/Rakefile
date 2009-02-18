#!/usr/bin/env ruby
# -*- ruby -*-

require 'rake/clean'

CLOBBER.include("pkg")

LABS = FileList['labs/*'].select { |fn| fn.pathmap("%f") =~ /^\d\d[a-z]?_/ }
DAILIES = {
  "pkg/day01" => LABS.select { |fn|
    labno = fn.pathmap("%n").split('_').first.to_i
    labno < 5
  },
  "pkg/day02" => LABS.select { |fn|
    labno = fn.pathmap("%n").split('_').first.to_i
    labno >= 5  && labno <= 6
  },
  "pkg/day03" => LABS.select { |fn|
    labno = fn.pathmap("%n").split('_').first.to_i
    labno > 6
  },
  "pkg/all_labs" => LABS,
}

TAR_FILES = LABS.pathmap("pkg/%f.tgz")
ZIP_FILES = LABS.pathmap("pkg/%f.zip")

PACKAGE_FILES = TAR_FILES + ZIP_FILES +
  DAILIES.keys.map { |fn| "#{fn}.tgz" } +
  DAILIES.keys.map { |fn| "#{fn}.zip" }

desc "default action => :package"
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

DOWNLOAD_HOST = 'umlcoop'
DOWNLOAD_DIR  = 'htdocs/test_studio'
DOWNLOAD_SITE = "#{DOWNLOAD_HOST}:#{DOWNLOAD_DIR}"

desc "Upload all the packages to the web site"
task :upload do
  sh "ssh #{DOWNLOAD_HOST} mkdir -p #{DOWNLOAD_DIR}"
  sh "scp pkg/*.tgz #{DOWNLOAD_SITE}"
  sh "scp pkg/*.zip #{DOWNLOAD_SITE}"
end
