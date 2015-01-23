me = require 'mongo-ember'
fs = require 'fs'
path = require 'path'

modelFolder = path.resolve '../models'
me.loadModels modelFolder

me.connect {}, 'mongodb://localhost/ti', (app) ->
	Question = me.getModel 'Question'
	Log = me.getModel 'Log'
	Question.find {}, (err, questions) ->
		for question in questions
			do (question) ->
				query = {}
				query['target'] = 'question'
				query['data.question._id'] = question._id
				Log.find(query).sort('-date').limit(1).populate('user').exec (err, result) ->
					if err
						console.log err
					else if result? and result.length > 0
						#do something
						result = result[0]
						username = result.user.username
						time = result._id.getTimestamp()
						
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

						question.save()
					else
						#do nothing




#Question.find {}, (err, questions) ->
#	console.log questions.length