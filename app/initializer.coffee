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

		model = me.getModel['User']
		console.log model
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
	setTimeout addAdmin, 3000
