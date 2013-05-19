should = require 'should'
membership = require '../../infrastructure/membership'
config = require '../../config'

mockRepo = {}
membership.initialize mockRepo

describe 'membership', ->

    describe 'middleware', ->
        it 'should work as expected', (done) ->
            mockRepo.getUser = (query, cb) ->
                cb null, {id: query.id}
            req =
                signedCookies:
                    'P': 99
                    'U': 12

            membership.middleware req, {}, ->
                req.privilege.should.equal 99
                req.user.should.be.a 'object'
                req.user.should.have.property 'id', req.signedCookies.U
                done()

    describe 'signup', ->
        it 'should return error if repo fails', (done) ->
            mockRepo.createUser = (user, cb) ->
                err = new Error 'Crack!'
                cb err

            membership.signup {password: 'abc'}, (err, user) ->
                should.exist err
                should.not.exist user
                done()

        it 'should return error if user has no password', (done) ->
            membership.signup {}, (err, user) ->
                should.exist err
                should.not.exist user
                done()

        it 'should return error if password is too short', (done) ->
            min = config.system.password.min
            password = ''
            password += 'x' while min -= 1

            membership.signup {password: password}, (err, user) ->
                should.exist err
                should.not.exist user
                done()

        it 'should return error if password is too long', (done) ->
            max = config.system.password.max
            password = ''
            password += 'x' while max -= 1
            password += 'xx'

            membership.signup {password: password}, (err, user) ->
                should.exist err
                should.not.exist user
                done()

        it 'should return user if repo succeeds', (done) ->
            mockRepo.createUser = (user, cb) ->
                cb null, {id: 999}

            membership.signup {password: 'abcdef'}, (err, user) ->
                should.not.exist err
                should.exist user
                user.should.have.property 'id', 999
                done()


    describe 'authenticate', ->
        it 'should return error if error occured', (done) ->
            mockRepo.getUserWithGroup = (query, cb) ->
                err = new Error 'Error'
                cb err

            membership.authenticate '', '', (err, user) ->
                should.exist err
                done()

        it 'should return null if no such user', (done) ->
            mockRepo.getUserWithGroup = (query, cb) ->
                cb null, null

            membership.authenticate '', '', (err, user) ->
                should.not.exist err
                should.equal user, null
                done()

        it 'should return user if exists', (done) ->
            mockRepo.getUserWithGroup = (query, cb) ->
                user =
                    email: 'a@b.com'
                    password: 'some password'
                cb null, user

            membership.authenticate '', '', (err, user) ->
                should.not.exist err
                user.should.be.a 'object'
                user.email.should.equal 'a@b.com'
                user.password.should.equal 'some password'
                done()


