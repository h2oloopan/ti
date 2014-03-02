db = require('../config').db[0]

connector = module.exports =
    getRepos: ->
        repos = require './' + db.type + '/repos'
        return repos
