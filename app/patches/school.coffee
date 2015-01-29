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
			if !stuff.terms? then return false
			actual =
				subjects: new Array()
			terms = []
			for term in stuff.terms
				#update terms
				if terms.indexOf(term.name) < 0 then terms.push term.name
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
							match = found.courses.find (item) ->
								if item.number == course.number then return true
								return false
							if !match? then found.courses.push course
							actual.subjects.push found
						else
							match = found.courses.find (item) ->
								if item.number == course.number then return true
								return false
							if !match? then found.courses.push course
							found.courses.push course
			
			school.info = actual
			school.terms = terms
			school.save (err) ->
				if err then console.log err


