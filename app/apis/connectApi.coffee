me = require 'mongo-ember'
jwt = require 'jsonwebtoken'
config = require '../config'
path = require 'path'

exports.bind = (app) ->
	app.post '/api/connect/questions/create', (req, res) ->
		question = req.body.question
		token = req.body.token
		
		jwt.verify token, config.secret, (err, user) ->
			if err
				res.send 401, 'You do not have the permission to access this api'
			else
				Question = me.getModel 'Question'
				question = new Question question

				#update question
				username = user.username
				time = moment().toDate()

				question.editor = user._id

				question.lastEditor = username
				question.lastModifiedTime = time
				question.questionLastEditor = username
				question.questionLastModifiedTime = time
				question.solutionLastEditor = username
				question.solutionLastModifiedTime = time
				question.hintLastEditor = username
				question.hintLastModifiedTime = time
				question.summaryLastEditor = username
				question.summaryLastModifiedTime = time

				question.save (err, question) ->
					if err
						res.send 500, err.message
					else
						res.send 200, path.join(config.url, '#/question/' + question._id + '/edit').toString()


	app.post '/api/connect/auth', (req, res) ->
		username = req.body.username
		password = req.body.password
		user = 
			username: username
			password: password
		me.authenticate user, (err, user) ->
			if err
				res.send 401, err.message
			else
				#actually
				token = jwt.sign user, config.secret
				res.send 200, token
