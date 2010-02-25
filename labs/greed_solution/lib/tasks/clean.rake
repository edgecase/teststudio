require 'rake/clean'

CLEAN.include('log/*')
CLEAN.include('tmp/*')
CLOBBER.include('db/development.sqlite3','db/test.sqlite3', 'TAGS')
