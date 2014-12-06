fs = require 'fs'
path = require 'path'
gm = require 'gm'

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

	#delete one image from one question
	app.delete '/api/images/questions/:qid/:iid', (req, res) ->