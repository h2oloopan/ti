alke = require '../../package'
os = require 'os'

class Info
    populate: ->
        @info =
            app: alke.name + ' version ' + alke.version
            node: process.version
            os: os.platform() + ' ' + os.release()
    toJSON: ->
        JSON.stringify @info


module.exports = Info
