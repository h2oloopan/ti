User = require '../models/user'
Group = require '../models/group'
UserInfo = require '../models/userInfo'
Goal = require '../models/goal'
mysql = require('../infrastructure/db').mysql

#recreate all tables
exports.apply = (cb) ->
    mysql.sync()
        .success ->
            cb null
        .error (err) ->
            cb err
