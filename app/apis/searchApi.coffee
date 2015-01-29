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
				#even a user has no authorization to access the question still send it back so he knows there is a duplication
				#and we only send back ids so we are not exposing any internal information that could lead to potential security breaching
				ids = []
				for question in questions
					ids.push question._id.toString()
				res.send 200, ids

