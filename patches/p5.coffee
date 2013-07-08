Group = require '../models/group'
privileges = require('../config').system.privileges

#add a default group for regular users
exports.apply = (cb) ->
    Group.create(
        name: 'users'
        privilege: privileges.user
    )
        .success ->
            cb null
        .error (err) ->
            cb err