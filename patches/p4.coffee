Group = require '../models/group'
User = require '../models/user'
auth = require '../helpers/auth'
privileges = require('../config').system.privileges

exports.apply = (cb) ->
    Group.create
        name: 'administrators'
        privilege: privileges.admin
    .success (group) ->
        User.create
            username: 'span'
            email: 'i@thepans.me'
            password: auth.encrypt '123321'
            group_id: group.id
        .success ->
            cb null
        .error (err) ->
            cb err
    .error (err) ->
        cb err
