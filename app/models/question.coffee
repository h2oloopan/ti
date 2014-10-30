Schema = require('mongo-ember').Schema

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

		manipulate:
			#c
			c: (obj, user, cb) ->
				if !user?
					cb new Error 'No user is present'
				else
					obj.editor = user._id
					cb null, obj

			#u
			u: (obj, user, cb) ->
				if !user?
					cb new Error 'No user is present'
				else
					obj.editor = user._id
					cb null, obj








		
			

