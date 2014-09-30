mailer = require '../helpers/mailer'

Schema = require('mongo-ember').Schema

module.exports =
	User:
		schema:
			username:
				type: String
				required: true
				match: /^[A-Z0-9\._-]+$/i
			password:
				type: String
				required: true
			email:
				type: String
				required: true
				match: /^[A-Z0-9\._%+-]+@[A-Z0-9\.-]+\.[A-Z]{2,4}$/i
			power:
				type: Number
				default: 10
			role:
				type: Schema.Types.Mixed
				default: {}
		validationMessages:
			username:
				required: 'Username cannot be empty'
				match: 'Invalid username'
			password:
				required: 'Password cannot be empty'
			email:
				required: 'Email cannot be empty'
				match: 'Invalid email address'
		api:
			c: (req, res, model, form, cb) ->
				
		auth:
			#c
			c: (req, user, power, cb) ->
				if power >= 999
					cb null
				else
					cb new Error 'You do not have the permission to access this'

			#r
			ra: (req, user, power, cb) ->
				if power >= 999
					cb null
				else
					cb new Error 'You do not have the permission to access this'

			ro: (req, user, power, cb) ->
				#now we just block any access to non admin user
				#but we may want user to access himself/herself
				if power >= 999
					cb null
				else
					cb new Error 'You do not have the permission to access this'

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









