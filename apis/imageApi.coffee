fs = require 'fs'
utils = require '../helpers/utils'

exports.bind = (app) ->
    app.get '/api/image/profile/:uid', (req, res) ->
        uid = parseInt req.params.uid
        if req.user? && req.user.id == uid
            #user can only access his/her own profile image
            path = utils.image.getProfileImagePath(uid)

            fs.readFile path, (err, data) ->
                if err?
                    res.send 500, err.message
                else
                    res.send 200, data

        else
            res.send 401, 'Permission denied'
