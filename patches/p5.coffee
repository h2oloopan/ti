#create common users group
Group = require '../models/group'
privileges = require('../config').system.privileges

exports.apply = (cb) ->
    Group.create
        name: 'users'
        privilege: privileges.user
    .success (group) ->
        cb null
    .error (err) ->
        cb err
