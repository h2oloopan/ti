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
			username: 'span'
			password: encrypt 'psy123321'
			email: 'span@easyace.ca'
			power: 999

		model = me.getModel 'User'
		model.findOne
			username: 'span'
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
	addUser = ->
		#add regular user
		user = 
			username: 'user'
			password: encrypt 'us123321'
			email: 'user@easyace.ca'

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

	addAdmin()
	addUser()
	addSchool()
