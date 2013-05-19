User = require '../models/user'

exports.apply = (cb) ->
    User.sync
        force: true
    .success ->
        cb null
    .error (err) ->
        cb err
