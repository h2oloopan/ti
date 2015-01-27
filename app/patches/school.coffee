require 'array.prototype.find'

me = require 'mongo-ember'
fs = require 'fs'
path = require 'path'

modelFolder = path.resolve '../models'
me.loadModels modelFolder

me.connect {}, 'mongodb://localhost/ti', (app) ->
	School = me.getModel 'School'
	School.findOne {name: 'University of Waterloo'}, (err, school) ->
		if err
			console.log err
		else
			#there is an error
			stuff = school.toJSON().info
			actual =
				subjects: new Array()
			for term in stuff.terms
				subjects = term.subjects
				for subject in subjects
					courses = subject.courses
					for course in courses
						#now we have subject and course
						found = actual.subjects.find (item) ->
							if item.name == subject.name then return true
							return false
						if !found?
							found =
								name: subject.name
								courses: []
							found.courses.push course
							actual.subjects.push found
						else
							found.courses.push course
			
			school.info = actual
			school.save (err) ->
				if err then console.log err


