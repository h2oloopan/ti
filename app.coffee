express = require 'express'
http = require 'http'
path = require 'path'
config = require './config'
starter = require './starter'
#membership = require './infrastructure/membership'


app = express()
app.configure ->
    app.set 'port', config.server.port
    app.set 'views', __dirname + '/views'
    app.use express.favicon()
    app.use express.logger('dev')
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.cookieParser(config.server.secret)

    #custom middlewares
    #app.use membership.middleware

    app.use app.router
    app.use express.static(path.join(__dirname, 'public'))

app.configure 'development', ->
    app.use express.errorHandler()

starter.start app, (err) ->
    if err
        console.log 'Something is wrong, failed to start application'
        throw err
    else
        port = app.get 'port'
        http.createServer(app).listen port, ->
            console.log 'Server listening on port ' + port

