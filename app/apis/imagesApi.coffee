fs = require 'fs'
path = require 'path'
gm = require 'gm'
moment = require 'moment'
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
	app.post '/api/images/questions/:qid', (req, res) ->
		qid = req.params.qid
		#get iid from server time so everything must be in sync
		iid = moment().unix()
		Question = me.getModel 'question'

		negative = (req, res, err) ->
			res.send 500,
				files: [{
					name: req.files.file.originalName
					size: req.files.file.size
					error: err.message
				}]

		positive = (req, res, url) ->
			res.send 200,
				files: [{
					name: req.files.file.originalName
					size: req.files.file.size
					url: url
				}]

		Question.find {_id: qid}, (err, question) ->
			if err
				negative req, res, err
			else
				user = req.user
				if user.power >= 999 or authorizer.canAccessQuestion(user, question)
					file = path.resolve req.files.file.path
					destination = path.join folder, qid, iid + config.image.format
					#create file at destination
					gm(file).resize config.image.width, config.image.height, '!'
					.quality config.image.quality
					.write destination, (err) ->
						if err
							negative req, res, err
						else
							fs.unlink file
							positive req, res, destination

				else
					negative req, res, new Error 'You do not have the privilege to access this'
				

	#delete one image from one question
	app.delete '/api/images/questions/:qid/:iid', (req, res) ->





