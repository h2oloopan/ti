Schema = require('mongo-ember').Schema

module.exports =
	Log:
		schema:
			user:
				type: Schema.Types.ObjectId
				ref: 'User'
			target:
				type: String
			operation:
				type: String
			data:
				type: Schema.Types.Mixed
		auth:
			#c
			c: (req, log, user, power, cb) ->
				#one cannot create log by calling apis
				cb new Error 'Creating log from api call is not allowed'
			
			#r
			#only admin users can read logs
			ra: (req, log, user, power, cb) ->
				if power >= 999
					cb null
				else
					cb new Error 'You do not have the permission to access this'

			ro: (req, log, user, power, cb) ->
				if power >= 999
					cb null
				else
					cb new Error 'You do not have the permission to access this'

			#u
			u: (req, log, user, power, cb) ->
				#one cannot update log by calling apis
				cb new Error 'Updating log from api call is not allowed'
			
			#d
			d: (req, log, user, power, cb) ->
				#one cannot delete log by calling apis
				cb new Error 'Deleting log from api calls is not allowed'

