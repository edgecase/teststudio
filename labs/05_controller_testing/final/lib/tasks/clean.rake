require 'rake/clean'

CLEAN.include('log/*', 'tmp/*', 'coverage')
CLOBBER.include('db/development.sqlite3','db/test.sqlite3', 'TAGS')
