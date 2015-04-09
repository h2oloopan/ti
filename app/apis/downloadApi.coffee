fs = require 'fs'
path = require 'path'
me = require 'mongo-ember'
authorizer = require '../helpers/authorizer'

config = require '../config'
pdfFolder = path.resolve config.download.pdfFolder

exports.bind = (app) ->
	app.get '/api/download/pdfs/:pid', (req, res) ->
		pid = req.params.pid
		fs.readFile path.join(pdfFolder, pid + '.pdf'), (err, data) ->
			if err
				res.send 500, err.message
			else
				