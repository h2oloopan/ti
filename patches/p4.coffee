Group = require '../models/group'
User = require '../models/user'
UserInfo = require '../models/userInfo'
auth = require '../helpers/auth'
privileges = require('../config').system.privileges

#add a default administrators group and an admin user
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
        .success (user) ->
            UserInfo.create
                user_id: user.id
                nickname: user.username
            .success ->
                cb null
            .error (err) ->
                cb err
        .error (err) ->
            cb err
    .error (err) ->
        cb err