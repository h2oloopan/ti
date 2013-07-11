path = require 'path'
config = require '../../config'

image = module.exports =
    getProfileImageUrl: (uid) ->
        url = path.join(config.system.profiles.path, uid) + config.system.profiles.format
        return url
