me = require 'mongo-ember'
jwt = require 'jsonwebtoken'
config = require '../config'

exports.bind = (app) ->
	app.post '/api/connect/questions/wechat', (req, res) ->
		console.log question.body
		question = req.body.question
		user = req.body.user
		if !user? then return res.send 401, 'You do not have the permission to access this api'
		#now authorize user
		me.authenticate user, (err, user) ->
			if err
				res.send 401, 'You do not have the permission to access this api'
			else
				console.log user
				res.send 200, user

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
