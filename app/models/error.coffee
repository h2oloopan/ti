Schema = require('mongo-ember').Schema

module.exports = 
	Error:
		schema:
			message:
				type: String
			type:
				type: String
			data:
				type: Schema.Types.Mixed
		auth:
			#c
			c: (req, error, user, power, cb) ->
				#one cannot create error by calling apis
				cb new Error 'Creating error from api call is not allowed'
			
			#r
			#only admin users can read errors
			ra: (req, error, user, power, cb) ->
				if power >= 999
					cb null
				else
					cb new Error 'You do not have the permission to access this'

			ro: (req, error, user, power, cb) ->
				if power >= 999
					cb null
				else
					cb new Error 'You do not have the permission to access this'

			#u
			u: (req, error, user, power, cb) ->
				#one cannot update error by calling apis
				cb new Error 'Updating error from api call is not allowed'
			
			#d
			d: (req, error, user, power, cb) ->
				#one cannot delete error by calling apis
				cb new Error 'Deleting error from api calls is not allowed'