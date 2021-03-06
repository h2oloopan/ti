me = require 'mongo-ember'
Schema = me.Schema

module.exports =
	School:
		schema:
			name:
				type: String
				required: true
			terms:
				type: [ String ]
			types:
				type: [ String ]
			info:
				type: Schema.Types.Mixed
				default: {subjects: []}

		validationMessages:
			name:
				required: 'School name cannot be empty'
		api:
			c: (req, res, model, form, names) ->
				#just to make sure there is no duplicate
				school = new model form
				school.validate (err) ->
					if err
						res.send 500, err.message
					else
						pattern = new RegExp '^' + school.name + '$', 'i'
						model.findOne {name: pattern}, (err, result) ->
							if err
								res.send 500, err.message
							else if result?
								res.send 400, 'School ' + school.name + ' was already in the database'
							else
								school.save (err, result) ->
									if err
										res.send 500, err.message
									else
										res.send 201, me.helper.wrap result, names.name

		auth:
			#c
			c: (req, school, user, power, cb) ->
				if power >= 999
					cb null
				else
					cb new Error 'You do not have the permission to access this'

			#r
			ra: (req, school, user, power, cb) ->
				if user?
					cb null
				else
					cb new Error 'You do not have the permission to access this'


			#u
			u: (req, school, user, power, cb) ->
				if power >= 999
					cb null
				else
					cb new Error 'You do not have the permission to access this'

			#d
			d: (req, school, user, power, cb) ->
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
					schools = schools.map (school) ->
						return school.toObject()
					for privilege in user.privileges
						filter = (set, subsets, fields, rules, counter, max) ->
							field = fields[counter]
							rule = privilege[rules[counter]]
							
							if rule? && rule.length > 0
								filterSet = (item) ->
									if item[field].toString().trim().toLowerCase() == rule.trim().toLowerCase()
										item.selected = true
										if counter <= max
											if counter == 0
												filter item.info[subsets[counter + 1]], subsets, fields, rules, counter + 1, max
											else
												filter item[subsets[counter + 1]], subsets, fields, rules, counter + 1, max
									return true
								set = set.filter filterSet
							else
								filterSet = (item) ->
									item.selected = true
									if counter <= max
										if counter == 0
											filter item.info[subsets[counter + 1]], subsets, fields, rules, counter + 1, max
										else
											filter item[subsets[counter + 1]], subsets, fields, rules, counter + 1, max
									return true
								set = set.filter filterSet

						filter schools, ['', 'subjects', 'courses'], 
						['_id', 'name', 'number'], 
						['school', 'subject', 'course'], 0, 1


					for school in schools
						for subject in school.info.subjects
							subject.courses = subject.courses.filter (course) ->
								if course.selected then return true
								return false
						school.info.subjects = school.info.subjects.filter (subject) ->
							if subject.selected then return true
							return false
					schools = schools.filter (school) ->
						if school.selected then return true
						return false


					cb null, schools









