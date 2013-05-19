repo = require '../repos/forumRepo'
privileges = require('../config').system.privileges
membership = require('../infrastructure/membership')

#TODO: need to add authentication and authorization to apis
exports.bind = (app) ->
    #create
    app.post '/api/sections', membership.authorize privileges.admin, (req, res) ->
        repo.createSection req.body, (err, section) ->
            if err?
                res.send 500, err.message
            else
                res.send 201, section

    #read
    app.get '/api/sections', membership.authorize privileges.admin, (req, res) ->
        repo.getSections null, (err, sections) ->
            if err?
                res.send 500, err.message
            else
                res.send 200, sections

    #update
    app.put '/api/sections/:id', membership.authorize privileges.admin, (req, res) ->
        repo.updateSection req.body, (err, section) ->
            if err?
                res.send 500, err.message
            else
                res.send 200, section

    #delete
    app.delete '/api/sections/:id', membership.authorize privileges.admin, (req, res) ->
        id = req.params.id
        repo.deleteSectionById id, (err) ->
            if err?
                res.send 500, err.message
            else
                res.send 204


