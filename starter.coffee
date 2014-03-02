path = require 'path'
fs = require 'fs'
apiFolder = path.resolve 'apis'
connector = require './repos/connector'
page = path.resolve 'public/templates/pages/app.html'

exports.start = (app, cb) ->
    #bind apis
    files = fs.readdirSync apiFolder
    (require path.join(apiFolder, api)).bind app for api in files when path.extname(api) == '.js'

    #bind starting page for non-nginx usage
    #should set up nginx to serve static file and by pass this
    app.get '/', (req, res) ->
        fs.readFile page, (err, data) ->
            if err
                res.send 500, err
            else
                res.set 'Content-Type', 'text/html'
                res.send 200, data

    #initialize db
    repos = connector.getRepos()
    repos.initialize (err) ->
        cb err
