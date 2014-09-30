crypto = require 'crypto'
me = require 'mongo-ember'

encrypt = (input) ->
	sha = crypto.createHash 'sha256'
	sha.update input
	return sha.digest('hex').toString()

exports.init = ->
	addAdmin = ->
		#add admin user
		user = 
			username: 'admin'
			password: encrypt '456273'
			email: 'admin@easyace.ca'
			power: 999
			role:
				name: 'admin'

		model = me.getModel 'User'
		model.findOne
			username: 'admin'
		, (err, result) ->
			if err
				console.log err
			else if !result?
				user = new model user
				user.save (err, result) ->
					if err
						console.log err
					else
						console.log 'admin span created'
	addEditor = ->
		#add regular user
		user = 
			username: 'editor'
			password: encrypt '123321'
			email: 'editor@easyace.ca'
			power: 10
			role:
				name: 'editor'

		model = me.getModel 'User'
		model.findOne
			username: 'user'
		, (err, result) ->
			if err
				console.log err
			else if !result?
				user = new model user
				user.save (err, result) ->
					if err
						console.log err
					else
						console.log 'user user created'

	addSchool = ->
		#add uw for testing
		school =
			name: 'University of Waterloo'
			info: require('./configurations/uwaterloo').info

		model = me.getModel 'School'
		model.findOne
			name: 'University of Waterloo'
		, (err, result) ->
			if err
				console.log err
			else if !result?
				school = new model school
				school.save (err, result) ->
					if err
						console.log err
					else
						console.log 'school UW created'
			else
				return false
				#update
				result.info = school.info
				result.save (err, result) ->
					if err
						console.log err
					else
						console.log 'school UW updated'

	addAdmin()
	addEditor()
	addSchool()
