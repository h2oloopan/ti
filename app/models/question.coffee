me = require 'mongo-ember'
Schema = me.Schema

module.exports = 
	Question:
		schema:
			question:
				type: String
				required: true
			hint:
				type: String
			solution:
				type: String
			summary:
				type: String
			note:
				type: String
			tags:
				type: String
			difficulty: 
				type: Number
			type:
				type: String
			#flag is used to mark the state of the question
			#e.g. it may be marked to delete but we will not
			#remove it from database directly
			flag:
				type: Number
				default: 1

			#relationship
			school:
				type: Schema.Types.ObjectId
				ref: 'School'
				required: true
			term:
				type: String
				required: true
			subject:
				type: String
				required: true
			course:
				type: String
				required: true
			editor:
				type: Schema.Types.ObjectId
				ref: 'User'

		validationMessages:
			question:
				required: 'Question cannot be empty'
			school:
				required: 'School cannot be empty'
			term:
				required: 'Term cannot be empty'
			subject:
				required: 'Subject cannot be empty'
			course:
				required: 'Course cannot be empty'
		auth:
			#c
			c: (req, user, power, cb) ->
				if power >= 999 || user.role.name == 'editor'
					cb null
				else
					cb new Error 'You do not have the permission to access this'

			#r
			#this is a TODO: at the moment

			#u
			u: (req, user, power, cb) ->
				if power >= 999 || user.role.name == 'editor'
					cb null
				else
					cb new Error 'You do not have the permission to access this'

			#d
			d: (req, user, power, cb) ->
				#only admin can delete a question
				if power >= 999
					cb null
				else
					cb new Error 'You do not have the permission to access this'

		before:
			#c
			c: (question, user, cb) ->
				if !user?
					cb new Error 'No user is present'
				else
					question.editor = user._id
					#add to log
					cb null, question

			#u
			u: (question, user, cb) ->
				if !user?
					cb new Error 'No user is present'
				else
					question.editor = user._id
					cb null, question

		after:
			#c
			c: (question, user) ->
				if !user? then return console.log 'Something is wrong, question created without user'
				Log = me.getModel 'Log'
				log = new Log
					user: user._id
					target: 'question'
					operation: 'create'
					data: 
						question: question.toObject()
				log.save (err) ->
					if err then console.log err

			#u
			u: (question, user) ->
				if !user? then return console.log 'Something is wrong, question updated without user'
				Log = me.getModel 'Log'
				log = new Log
					user: user._id
					target: 'question'
					operation: 'update'
					data:
						question: question.toObject()
				log.save (err) ->
					if err then console.log err






		
			

