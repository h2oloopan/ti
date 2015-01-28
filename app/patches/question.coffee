require 'array.prototype.find'

me = require 'mongo-ember'
fs = require 'fs'
path = require 'path'

modelFolder = path.resolve '../models'
me.loadModels modelFolder

me.connect {}, 'mongodb://localhost/ti', (app) ->
	Question = me.getModel 'Question'
	Question.find {}, (err, questions) ->
		for question in questions
			do (question) ->
				term = question.term
				type = question.type
				if term? and term.length > 0 and type? and type.length > 0
					question.typeTags = term + ' ' + type
					question.save()