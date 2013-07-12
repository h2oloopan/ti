path = require 'path'
config = require '../../config'

image = module.exports =
    getProfileImagePath: (uid) ->
        path.join(config.system.profiles.path, uid.toString()) + '.' + config.system.profiles.format
