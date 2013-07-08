membership = require '../infrastructure/membership'
privileges = require('../config').system.privileges

exports.bind = (app) ->

    #auth
    app.get '/api/account/auth', (req, res) ->
        if req.user?
            res.send 200
        else
            res.send 401, 'No user logged in'

    app.get '/api/account/auth/:level', (req, res) ->
        level = req.params.level
        if privileges[level]?
            if req.privilege >= privileges[level]
                res.send 200
            else
                res.send 401, 'You do not have the permission to access this'
        else
            res.send 401, 'You do not have the permission to access this'


    #login
    app.post '/api/account/login', (req, res) ->
        #TODO: change email to eu, both back-end and front-end
        membership.authenticate req.body.email, req.body.password, (err, user) ->
            if err?
                res.send 500, err.message
            else if user?
                membership.login user, res
                res.send 200
            else
                res.send 401, 'No match could be found'

    #signup
    app.post '/api/account/signup', (req, res) ->
        membership.signup req.body, (err, user) ->
            if err?
                #TODO: here may need to send more accurate error message, e.g. duplicate users
                res.send 500, err.message
            else
                res.send 201, {id: user.id}

    #logout
    app.post '/api/account/logout', (req, res) ->
        if req.user?
            membership.logout res
            res.send 200
        else
            res.send 401, 'No user logged in'
