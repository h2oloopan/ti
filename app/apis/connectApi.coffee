me = require 'mongo-ember'

exports.bind = (app) ->
	app.post '/api/connect/questions/wechat', (req, res) ->
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