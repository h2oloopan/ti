fs = require 'fs'
path = require 'path'
authorizer = require '../helpers/authorizer'

config = require '../config'
testsTemplatePath = path.resolve config.tests.templatePath

exports.bind = (app) ->
	app.get '/api/edit/tests/template', (req, res) ->
		if !authorizer.isAdmin(req.user) then return res.send 401, 'You do not have the permission to access this'
		fs.readFile testsTemplatePath, (err, data) ->
			if err
				res.send 500, err.message
			else
				res.send 200, {text: data.toString()}
