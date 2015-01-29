me = require 'mongo-ember'
authorizer = require '../helpers/authorizer'

exports.bind = (app) ->
	app.get '/api/search/questions/text', (req, res) ->
		#context based text search to detect duplicate questions