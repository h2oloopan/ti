me = require 'mongo-ember'
moment = require 'moment'
mv = require 'mv'
fs = require 'fs'
path = require 'path'
mkdirp = require 'mkdirp'
Schema = me.Schema
authorizer = require '../helpers/authorizer'

config = require '../config'
folder = path.resolve config.image.questionImageFolder
tempFolder = path.resolve config.image.tempFolder
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
			typeTags:
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

			#house keeping stuff
			lastEditor:
				type: String
				default: ''
			lastModifiedTime:
				type: Date
				default: null
			questionLastEditor:
				type: String
				default: ''
			questionLastModifiedTime:
				type: Date
				default: null
			hintLastEditor:
				type: String
				default: ''
			hintLastModifiedTime:
				type: Date
				default: null
			solutionLastEditor:
				type: String
				default: ''
			solutionLastModifiedTime:
				type: Date
				default: null
			summaryLastEditor:
				type: String
				default: ''
			summaryLastModifiedTime:
				type: Date
				default: null



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
			c: (req, question, user, power, cb) ->
				if power >= 999
					cb null
				else if user.role.name == 'editor'
					#TODO: the unwrapping should be part of the preprocessing passing into here
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
			u: (req, question, user, power, cb) ->
				if power >= 999 || user.role.name == 'editor'
					if authorizer.canAccessQuestion user, question
						cb null
					else
						cb new Error 'You do not have the permission to access this'
				else
					cb new Error 'You do not have the permission to access this'

			#d
			d: (req, question, user, power, cb) ->
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
					question.question = question.question.trim()
					question.solution = question.solution.trim()
					question.hint = question.hint.trim()
					question.summary = question.summary.trim()
					
					username = user.username
					time = moment().toDate()

					question.lastEditor = username
					question.lastModifiedTime = time
					question.questionLastEditor = username
					question.questionLastModifiedTime = time
					question.solutionLastEditor = username
					question.solutionLastModifiedTime = time
					question.hintLastEditor = username
					question.hintLastModifiedTime = time
					question.summaryLastEditor = username
					question.summaryLastModifiedTime = time

					cb null, question

			#u
			u: (question, user, cb) ->
				if !user?
					cb new Error 'No user is present'
				else
					question.editor = user._id

					Question = me.getModel 'Question'
					Question.findOne {_id: question._id}, (err, oldQuestion) ->
						if err
							cb err
						else
							question.question = question.question.trim()
							question.solution = question.solution.trim()
							question.hint = question.hint.trim()
							question.summary = question.summary.trim()

							changed =false
							username = user.username
							time = moment().toDate()

							if question.question != oldQuestion.question
								question.questionLastEditor = username
								question.questionLastModifiedTime = time
								changed = true

							if question.solution != oldQuestion.solution
								question.solutionLastEditor = username
								question.solutionLastModifiedTime = time
								changed = true

							if question.hint != oldQuestion.hint
								question.hintLastEditor = username
								question.hintLastModifiedTime = time
								changed = true

							if question.summary != oldQuestion.summary
								question.summaryLastEditor = username
								question.summaryLastModifiedTime = time
								changed = true

							if changed
								question.lastEditor = username
								question.lastModifiedTime = time

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
				mkdirp path.join(folder, question._id.toString()), (err) ->
					if err
						cb err
					else
						insertPhotos = (question, photos, counter, cb) ->
							if counter > question.photos.length then return cb photos
							url = question.photos[counter - 1]
							location = path.join publicFolder, url
							destination = path.join folder, question._id.toString(), path.basename(url)
							mv location, destination, {mkdirp: true}, (err) ->
								if err
									console.log err
								else
									photos.push path.relative(publicFolder, destination)
								insertPhotos question, photos, counter + 1, cb

						insertPhotos question, [], 1, (photos) ->
							question.photos = photos
							question.save cb

			#r - this is for authorization purposes
			ra: (questions, user, cb) ->
				filter = (question, index) ->
					if authorizer.canAccessQuestion(user, question) and question.flag != 0
						return true
					else
						return false
				questions = questions.filter filter
				cb null, questions


			ro: (question, user, cb) ->
				if !authorizer.canAccessQuestion(user, question)
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


				if !question.photos? or question.photos.length < 1 then return cb null, question

				#move photos from temp folder to question's dedicated folder
				#there is something wrong with synchronization
				#recursive callback
				updatePhotos = (question, photos, counter, cb) ->
					if counter > question.photos.length then return cb photos
					url = question.photos[counter - 1]
					location = path.join publicFolder, url
					if location.toLowerCase().indexOf(tempFolder.toLowerCase()) >= 0
						destination = path.join folder, question._id.toString(), path.basename(url)
						console.log location
						console.log destination
						mv location, destination, {mkdirp: true}, (err) ->
							if err
								console.log 'dah'
								console.log err
							else
								console.log 'err'
								photos.push path.relative(publicFolder, destination)
							updatePhotos question, photos, counter + 1, cb
					else
						console.log url
						photos.push url
						updatePhotos question, photos, counter + 1, cb

				#remove photos in question's which are no longer part of the question
				questionFolder = path.join folder, question._id.toString()
				fs.readdir questionFolder, (err, files) ->
					if err
						console.log err #suppress
					else
						for file in files
							filePath = path.join questionFolder, file
							fileRelativePath = path.relative publicFolder, filePath
							if question.photos.indexOf(fileRelativePath) < 0
								try
									fs.unlinkSync filePath
								catch err
									console.log err
						updatePhotos question, [], 1, (photos) ->
							question.photos = photos
							question.save cb
						






		
			

