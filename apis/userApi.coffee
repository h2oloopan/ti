User = require '../models/user'

exports.bind = (app) ->
    #should expose user info rather than basic data
    #remember we need to impose authentication and authorization here
    app.get '/api/users/self', (req, res) ->
        if req.user?
            res.send 200, req.user
        else
            res.send 401, 'Permission denied'

    #app.get '/api/users/:id', (req, res) ->
    #    id = req.params.id
    #    if req.user? && req.user.id == id
    #        res.send 200,
    #            req.user
    #    else
    #        res.send 401, 'You do not have the permission to perform such action'

