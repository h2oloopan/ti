fs = require 'fs'
path = require 'path'
gm = require 'gm'
moment = require 'moment'
mkdirp = require 'mkdirp'
rimraf = require 'rimraf'
me = require 'mongo-ember'
authorizer = require '../helpers/authorizer'

config = require '../config'
folder = path.resolve config.image.questionImageFolder
tempFolder = path.join path.resolve(config.image.tempFolder), 'questions'

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


	#helper functions to respond to file-uploader
	negative = (req, res, err) ->
		console.log err
		console.log err.stack
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

	process = (input, output, cb) ->
		#gm(input).resize config.image.width, config.image.height, '!'
		gm(input).quality config.image.quality
		.write output, (err) ->
			cb err


	#delete temp question photos
	app.delete '/api/images/temp', (req, res) ->
		fs.readdir tempFolder, (err, files) ->
			if err then return console.log err
			for file in files
				rimraf path.join(tempFolder, file), (err) ->
					if err then console.log err

		#doesn't matter we succeed or not just proceed
		res.send 204

	#add one image to temp folder
	app.post '/api/images/temp', (req, res) ->
		#first only allow admin and editors to upload photo
		if !req.user? then return res.send 401, 'You do not have the permission to access this'
		if req.user.power < 999 and req.user.role.name != 'editor' then return res.send 401, 'You do not have the permission to access this'
		
		translate = (url) ->
			#convert physical url to web url
			return path.relative path.resolve('public'), url

		mkdirp tempFolder, (err) ->
			if err
				negative req, res, err
			else
				#folder is ready
				iid = '' + moment().unix()
				file = path.resolve req.files.file.path
				destination = path.join tempFolder, iid + config.image.format
				process file, destination, (err) ->
					if err
						negative req, res, err
					else
						fs.unlink file
						positive req, res, translate(destination)


	#delete an image file by location
	app.delete '/api/images/location', (req, res) ->
		if !req.user? then return res.send 401, 'You do not have the permission to access this'
		if req.user.power < 999 and req.user.role.name != 'editor' then return res.send 401, 'You do not have the permission to access this'
		file = req.query.url
		file = path.join path.resolve('public'), file
		#one can only delete photos in the temp folder for this api
		if file.toLowerCase().indexOf(tempFolder.toLowerCase()) < 0 then return res.send 401, 'You do not have the permission to access this'

		#now delete file
		fs.unlink file, (err) ->
			if err
				res.send 500, err.message
			else
				res.send 204



	#add one image to one question
	app.post '/api/images/questions/:qid', (req, res) ->
		qid = req.params.qid
		#get iid from server time so everything must be in sync
		iid = moment().unix()
		Question = me.getModel 'question'

		

		Question.find {_id: qid}, (err, question) ->
			if err
				negative req, res, err
			else
				user = req.user
				if user.power >= 999 or authorizer.canAccessQuestion(user, question)
					file = path.resolve req.files.file.path
					destination = path.join folder, qid, iid + config.image.format
					#create file at destination
					#gm(file).resize config.image.width, config.image.height, '!'
					gm(file).quality config.image.quality
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





