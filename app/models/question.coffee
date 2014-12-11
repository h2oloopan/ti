me = require 'mongo-ember'
mv = require 'mv'
fs = require 'fs'
path = require 'path'
mkdirp = require 'mkdirp'
Schema = me.Schema
authorizer = require '../helpers/authorizer'

config = require '../config'
folder = path.resolve config.image.questionImageFolder
publicFolder = path.resolve 'public'

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
			photos:
				type: [String]
				default: []
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
				if power >= 999
					cb null
				else if user.role.name == 'editor'
					question = req.body
					if authorizer.canAccessQuestion user, question
						cb null
					else
						cb new Error 'You do not have the permission to access this'
				else
					cb new Error 'You do not have the permission to access this'

			#r
			#read realted authorization has to be done in after to filter
			#out questions that cannot be accessed

			#u
			u: (req, user, power, cb) ->
				if power >= 999 || user.role.name == 'editor'
					question = req.body
					if authorizer.canAccessQuestion user, question
						cb null
					else
						cb new Error 'You do not have the permission to access this'
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
			c: (question, user, cb) ->
				if !user?
					console.log 'Something is wrong, question created without user'
					return cb new Error 'Question created without user'

				#log changes to db, doesn't matter it succeed or not
				Log = me.getModel 'Log'
				log = new Log
					user: user._id
					target: 'question'
					operation: 'create'
					data: 
						question: question.toObject()
				log.save (err) ->
					if err then console.log err

				#move photos to questions' dedicated folder
				#note this is synchronous for now
				#TODO: change it to async in the future
				mkdirp path.join(folder, question._id.toString()), (err) ->
					if err
						cb err
					else
						for url in question.photos
							location = path.join publicFolder, url
							destination = path.join folder, question._id.toString(), path.basename(url)
							try
								fs.renameSync location, destination
							catch err
								console.log err
						cb null, question #it doesn't matter if some photo was not copied

			#r - this is for authorization purposes
			ra: (questions, user, cb) ->
				filter = (question, index) ->
					if authorizer.canAccessQuestion user, question and question.flag != 0
						return true
					else
						return false
				questions = questions.filter filter
				cb null, questions


			ro: (question, user, cb) ->
				if !authorizer.canAccessQuestion user, question
					cb new Error 'You do not have the permission to access this'
				else
					cb null, question

			#u
			u: (question, user, cb) ->
				if !user?
					console.log 'Something is wrong, question updated without user'
					return cb new Error 'Question updated without user'
				Log = me.getModel 'Log'
				log = new Log
					user: user._id
					target: 'question'
					operation: 'update'
					data:
						question: question.toObject()
				log.save (err) ->
					if err
						console.log err
						cb err
					else
						cb null, question





		
			

