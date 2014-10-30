Schema = require('mongo-ember').Schema
module.exports =
	School:
		schema:
			name:
				type: String
				required: true
			info:
				type: Schema.Types.Mixed
				default: {terms: []}

		validationMessages:
			name:
				required: 'School name cannot be empty'
		api:
			c: (req, res, model, form, cb) ->
				#just to make sure there is no duplicate
				school = new model form
				school.validate (err) ->
					if err
						cb err
					else
						pattern = new RegExp '^' + school.name + '$', 'i'
						model.findOne {name: pattern}, (err, result) ->
							if err
								cb err
							else if result?
								cb new Error 'School ' + school.name + ' was already in the database'
							else
								school.save (err, result) ->
									if err
										cb err
									else
										cb null,
											code: 201
											data: result

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
