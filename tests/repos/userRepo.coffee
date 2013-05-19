should = require 'should'
mysql = require('../../infrastructure/db').mysql
userRepo = require '../../repos/userRepo'

describe 'userRepo', ->

    beforeEach (done) ->
        query = 'DELETE FROM users;'
        mysql.query(query)
        .success ->
            query = 'INSERT INTO users (username, email, password) VALUES ("testuser", "test@test.com", "correct password");'
            mysql.query(query)
            .success ->
                done()
            .error (err) ->
                done err
        .error (err) ->
            done err

    describe 'getUser', ->
        it 'should return with error when causing trouble in the database (e.g. bad column name)', (done) ->
            userRepo.getUser
                xx: 'yy'
            , (err, user) ->
                should.exist err
                should.not.exist user
                done()

        it 'should return null when no rows in the db match query', (done) ->
            userRepo.getUser
                email: 'test@test.com'
                password: 'wrong password'
            , (err, user) ->
                should.not.exist err
                should.not.exist user
                done()

        it 'should return user when the query matches', (done) ->
            userRepo.getUser
                email: 'test@test.com'
                password: 'correct password'
            , (err, user) ->
                should.not.exist err
                user.should.have.property 'username', 'testuser'
                user.should.have.property 'email', 'test@test.com'
                user.should.have.property 'password', 'correct password'
                done()

    describe 'createUser', ->
        it 'should return with error if passed in user has invalid columns', (done) ->
            userRepo.createUser
                username: 'baduser'
                email: 'a@b.com'
                xx: 'yy'
            , (err, user) ->
                should.exist err
                should.not.exist user
                done()

        it 'should return with error if email is in wrong format', (done) ->
            userRepo.createUser
                username: 'baduser'
                email: 'xxx'
                password: 'test password'
            , (err, user) ->
                should.exist err
                should.not.exist user
                done()

        it 'should return with error if username is in wrong format', (done) ->
            userRepo.createUser
                username: 'wrong format'
                email: 'right@email.com'
                password: 'test password'
            , (err, user) ->
                should.exist err
                should.not.exist user
                done()

        it 'should return with error if username is null', (done) ->
            userRepo.createUser
                email: 'bad@user.com'
                password: 'test password'
            , (err, user) ->
                should.exist err
                should.not.exist user
                done()

        it 'should return with error if email is null', (done) ->
            userRepo.createUser
                username: 'baduser'
                password: 'test password'
            , (err, user) ->
                should.exist err
                should.not.exist user
                done()

        it 'should return with error if password is null', (done) ->
            userRepo.createUser
                username: 'baduser'
                email: 'a@b.com'
            , (err, user) ->
                should.exist err
                should.not.exist user
                done()

        it 'should return with error if username is duplicate', (done) ->
            userRepo.createUser
                username: 'testuser'
                email: 'another@test.com'
                password: 'test password'
            , (err, user) ->
                should.exist err
                should.not.exist user
                done()

        it 'should return with error if email is duplicate', (done) ->
            userRepo.createUser
                username: 'baduser'
                email: 'test@test.com'
                password: 'test password'
            , (err, user) ->
                should.exist err
                should.not.exist user
                done()

        it 'should return without error and with user if none of above happen', (done) ->
            userRepo.createUser
                username: 'gooduser'
                email: 'good@email.com'
                password: 'good password'
            , (err, user) ->
                should.not.exist err
                should.exist user
                user.should.have.property 'username', 'gooduser'
                user.should.have.property 'email', 'good@email.com'
                user.should.have.property 'password', 'good password'
                done()

    describe 'deleteUser', ->
        it 'should delete user that it no longer exists in database', (done) ->
            userRepo.deleteUser
                email: 'test@test.com'
                password: 'correct password'
            , (err) ->
                should.not.exist err
                query = 'SELECT * FROM users WHERE email = "test@test.com" AND password = "correct password";'
                mysql.query(query)
                .success (rows) ->
                    rows.length.should.equal 0
                    done()
                .error (err) ->
                    done(err)











