User = require '../models/user'
Group = require '../models/group'
mysql = require('../infrastructure/db').mysql

userRepo = module.exports =
    getUser: (query, cb) ->
        User.find
            where: query
        .success (user) ->
            cb null, user
        .error (err) ->
            cb err
    getUserWithGroup: (query, cb) ->
        User.find
            where: query
            include: [Group]
        .success (user) ->
            cb null, user
        .error (err) ->
            cb err
    getGroup: (query, cb) ->
        Group.find
            where: query
        .success (group) ->
            cb null, group
        .error (err) ->
            cb err
    createUser: (user, cb) ->
        user = User.build user
        result = user.validate()

        if result?
            if result.username?
                err = new Error result.username[0]
            else if result.email?
                err = new Error result.email[0]
            else if result.password?
                err = new Error result.password[0]

            return cb err

        user.save()
        .success (user) ->
            cb null, user
        .error (err) ->
            cb err
    deleteUser: (user, cb) ->
        #user needs to have a reference in the database
        User.find
            where: user
        .success (user) ->
            user.destroy()
            .success ->
                cb null
            .error (err) ->
                cb err
        .error (err) ->
            cb err

