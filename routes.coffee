renderer = require './helpers/renderer'
exports.bind = (app) ->
    app.get '/', (req, res) ->
        renderer.render 'home', res

    app.get '/account', (req, res) ->
        renderer.render 'account', res

    app.get '/admin', (req, res) ->
        renderer.render 'admin', res
