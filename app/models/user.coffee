mailer = require '../helpers/mailer'
me = require 'mongo-ember'
Schema = me.Schema

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
			privileges:
				type: [Schema.Types.Mixed]
				default: []
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
			c: (req, res, model, form, names) ->
				user = new model form
				user.validate (err) ->
					if err
						res.send 500, err.message
					else
						model.findOne {username: user.username}, (err, result) ->
							if err
								res.send 500, err.message
							else if result?
								res.send 400, 'User ' + user.username + ' was already registered'
							else
								user.password = me.encrypt user.password
								user.save (err, result) ->
									if err
										res.send 500, err.message
									else
										#send email
										#async doesn't matter if it succeeded or not
										originalUser = 
											username: form.username
											password: form.password
											email: form.email

										mailer.sendRegistrationMail originalUser, (err) ->
											if err then console.log err
										res.send 201, me.helper.wrap result, names.name

			u: (req, res, model, form, cb) ->
				if form.password? then form.password = me.encrypt form.password
				model.findByIdAndUpdate req.params.id, form, (err, result) ->
					if err
						res.send 500, err.message
					else
						res.send 200, me.helper.wrap result, names,name

		auth:
			#c
			c: (req, userObj, user, power, cb) ->
				if power >= 999
					cb null
				else
					cb new Error 'You do not have the permission to access this'

			#r
			ra: (req, userObj, user, power, cb) ->
				if power >= 999
					cb null
				else
					cb new Error 'You do not have the permission to access this'

			ro: (req, userObj, user, power, cb) ->
				#now we just block any access to non admin user
				#but we may want user to access himself/herself
				if power >= 999
					cb null
				else
					cb new Error 'You do not have the permission to access this'

			#u
			u: (req, userObj, user, power, cb) ->
				if power >= 999
					cb null
				else
					cb new Error 'You do not have the permission to access this'

			#d
			d: (req, userObj, user, power, cb) ->
				if power >= 999
					cb null
				else
					cb new Error 'You do not have the permission to access this'









