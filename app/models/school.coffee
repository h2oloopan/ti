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

		after:
			#r
			ra: (schools, user, cb) ->
				#filter out information that shall not be accessed by users
				#TODO
				if user.power >= 999
					cb null, schools #admins can see everything
				else
					#cb null, schools # do this for now, and fix ui first
					
					filter = (school, index) ->
						for privilege in user.privileges
							if privilege.school? and privilege.school != school then continue
							info = school.info
							for term in info.terms
								if privilege.term? and privilege.term != term then continue
								for subject in term.subjects
									if privilege.subject? and privilege.subject != subject then continue
									for course in subject.courses
										if privilege.course? and privilege.course != course then continue
					










