fs = require 'fs'
path = require 'path'
folder = path.resolve 'public/templates/pages'
extension = '.html'

exports.render = (name, res) ->
    file = name + extension
    file = path.join folder, file

    fs.readFile file, (err, data) ->
        if err
            res.send 500, err
        else
            res.set 'Content-Type', 'text/html'
            res.send 200, data
