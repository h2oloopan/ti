renderer = require './helpers/renderer'
exports.bind = (app) ->
    app.get '/', (req, res) ->
        renderer.render 'app', res
