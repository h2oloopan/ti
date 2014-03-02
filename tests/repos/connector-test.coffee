should = require 'should'
connector = require '../../repos/connector'

describe 'repos/connector', ->
    describe 'getRepos', ->
        it 'should return an object which is the correct repos', (done) ->
            repos = connector.getRepos()
            expectedType = require('../../config').db[0].type
            repos.type.should.equal expectedType
            done()
