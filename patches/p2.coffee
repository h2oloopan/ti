Group = require '../models/group'

mysql = require('../infrastructure/db').mysql

exports.apply = (cb) ->
    Group.sync
        force: true
    .success ->
        cb null
    .error (err) ->
        cb err
