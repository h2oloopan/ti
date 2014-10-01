Schema = require('mongo-ember').Schema
module.exports =
	School:
		schema:
			name:
				type: String
				required: true
			info:
				type: Schema.Types.Mixed
				default: {}

		validationMessages:
			name:
				required: 'School name cannot be empty'
		auth:
			#c
			c: (req, user, power, cb) ->
				if power >= 999
					cb null
				else
					cb new Error 'You do not have the permission to access this'

			#r

			#u
			u: (req, user, power, cb) ->
				if power >= 999
					cb null
				else
					cb new Error 'You do not have the permission to access this'

			#d
			d: (req, user, power, cb) ->
				if power >= 999
					cb null
				else
					cb new Error 'You do not have the permission to access this'
