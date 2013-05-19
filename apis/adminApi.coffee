membership = require '../infrastructure/membership'
privileges = require('../config').system.privileges

exports.bind = (app) ->
    app.get '/api/admin/info', membership.authorize privileges.admin, (req, res) ->
        Info = require '../models/vm/info'
        info = new Info()
        info.populate()
        res.send 200, info.toJSON()
