me = require 'mongo-ember'
authorizer = require '../helpers/authorizer'

exports.bind = (app) ->
	app.get '/api/search/questions/text', (req, res) ->
		#context based text search to detect duplicate questions
		query = req.query
		text = query.text
		Question = me.getModel 'Question'
		pattern = new RegExp '.*' + text + '.*', 'ig'
		Question.find { question: pattern}, (err, questions) ->
			if err
				res.send 500, err.message
			else
				console.log questions.length
				res.send 200

