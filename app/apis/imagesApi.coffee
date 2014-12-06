fs = require 'fs'
path = require 'path'
gm = require 'gm'

exports.bind = (app) ->
	#get all images' names for one question
	app.get 'api/images/:qid', (req, res) ->

	#add one image to one question
	app.post 'api/images/:qid/:iid', (req, res) ->

	#delete one image from one question
	app.delete 'api/images/:qid/:iid', (req, res) ->