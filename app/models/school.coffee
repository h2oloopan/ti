Schema = require('mongo-ember').Schema
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

						filter schools, ['', 'terms', 'subjects', 'courses'], 
						['_id', 'name', 'name', 'number'], 
						['school', 'term', 'subject', 'course'], 0, 2


					for school in schools
						for term in school.info.terms
							for subject in term.subjects
								subject.courses = subject.courses.filter (course) ->
									if course.selected then return true
									return false
							term.subjects = term.subjects.filter (subject) ->
								if subject.selected then return true
								return false
						school.info.terms = school.info.terms.filter (term) ->
							if term.selected then return true
							return false
					schools = schools.filter (school) ->
						if school.selected then return true
						return false


					cb null, schools









