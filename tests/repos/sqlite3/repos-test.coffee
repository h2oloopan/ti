should = require 'should'
repos = require '../../../repos/sqlite3/repos'

describe 'repos/sqlite3/repos', ->
    describe 'initialize', ->
        it 'should initialize the sqlite3 database accordingly', (done) ->
            repos.initialize (err) ->
                should.not.exist err
                done()
