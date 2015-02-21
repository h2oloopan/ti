me = require 'mongo-ember'
jwt = require 'jsonwebtoken'
config = require '../config'
path = require 'path'

exports.bind = (app) ->
	app.post '/api/connect/questions/create', (req, res) ->
		#cors
		res.header 'Access-Control-Allow-Origin', '*'
		res.header 'Access-Control-Allow-Headers', 'X-Requested-With'
		question = req.body.question
		token = req.body.token
		
		jwt.verify token, config.secret, (err, user) ->
			if err
				res.send 401, 'You do not have the permission to access this api'
			else
				#login
				req.session[config.sessionKey] = user._id.toString()


				if !question.school? then return res.send 404, 'Question must have an associated school'
				School = me.getModel 'School'
				pattern = new RegExp '^' + question.school + '$', 'ig'
				School.findOne {name: pattern}, (err, school) ->
					if err
						res.send 500, err.message
					else if !school?
						res.send 404, 'Invalid school for given question'
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
		#cors
		res.header 'Access-Control-Allow-Origin', '*'
		res.header 'Access-Control-Allow-Headers', 'X-Requested-With'

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
				req.session[config.sessionKey] = user._id.toString()
				res.send 200, token
