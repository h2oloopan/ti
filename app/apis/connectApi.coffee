me = require 'mongo-ember'
jwt = require 'jsonwebtoken'
config = require '../config'

exports.bind = (app) ->
	app.post '/api/connect/questions/create', (req, res) ->
		question = req.body.question
		token = req.body.token
		
		jwt.verify token, config.secret, (err, user) ->
			if err
				res.send 401, 'You do not have the permission to access this api'
			else
				Question = me.getModel 'Question'
				


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
