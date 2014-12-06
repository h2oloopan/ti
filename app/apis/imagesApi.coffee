fs = require 'fs'
path = require 'path'
gm = require 'gm'
me = require 'mongo-ember'
authorizer = require '../helpers/authorizer'

config = require '../config'
folder = path.resolve config.image.questionImageFolder
console.log folder

exports.bind = (app) ->
	#get all images' names for one question
	app.get '/api/images/questions/:qid', (req, res) ->
		qid = req.params.qid
		listFolder = path.join folder, qid
		fs.readdir listFolder, (err, files) ->
			if err
				res.send 500, err.message
			else
				list = (file for file in files when path.extname(file) == config.image.format)
				list.sort (a, b) ->
					#sort by ascending order, the names should be timestamps at which the images were created
					aTime = parseInt a.substr(0, a.length - config.image.format.length)
					bTime = parseInt b.substr(0, b.length - config.image.format.length)
					return aTime - bTime
				res.send 200, list 

	#add one image to one question
	app.post '/api/images/questions/:qid/:iid', (req, res) ->
		qid = req.params.qid
		iid = req.params.iid
		Question = me.getModel 'question'
		Question.find {_id: qid}, (err, question) ->
			if err
				res.send 500, err.message
			else
				user = req.user
				if user.power >= 999 or authorizer.canAccessQuestion(user, question)

				else
					res.send 401, 'You do not have the privilege to access this'
				

	#delete one image from one question
	app.delete '/api/images/questions/:qid/:iid', (req, res) ->





		