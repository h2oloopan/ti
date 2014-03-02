should = require 'should'
validator = require '../../models/validator'

User = require '../../models/user'
#First create a correct user
user = new User()

describe 'validator', ->
    describe 'validate', ->
        describe 'User', ->
            beforeEach (done) ->
                user.id = 1
                user.username = 'user'
                user.password = 'adkjbicuieeatkldsa'
                user.email = 'test@mygoals.me'
                done()

            it 'should return with err if missing id', (done) ->
                user.id = null
                validator.validate user, (errs) ->
                    should.exist errs
                    done()

            it 'should return with err if username is invalid', (done) ->
                user.username = '&&^'
                validator.validate user, (errs) ->
                    should.exist errs
                    done()

            it 'should return with err if username is too long', (done) ->
                user.username = '000000000000000000000000000000000'
                validator.validate user, (errs) ->
                    should.exist errs
                    done()

            it 'should return null if user is valid', (done) ->
                validator.validate user, (errs) ->
                    should.not.exist errs
                    done()
