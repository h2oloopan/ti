crypto = require 'crypto'
User = require '../models/user'

auth = module.exports =
    encrypt: (str) ->
        sha = crypto.createHash 'sha256'
        sha.update str
        sha.digest('hex').toString().toLowerCase()
