handlebars = require 'handlebars'
path = require 'path'
fs = require 'fs'
exec = require('child_process').exec
htmlToText = require 'html-to-text'
pdfFolder = path.resolve 'temp/pdfs'
texFolder = path.resolve 'temp/texs'
templateFolder = path.resolve 'templates'

testTemplateFile = path.join templateFolder, 'test.hbs'

pdflatex = module.exports =
	sanitize: (test) ->
		
		for question in test.questions
			html = question.question
			console.log 'HTML---------'
			console.log html
			question.question = htmlToText.fromString html
			console.log 'TEXT---------'
			console.log question.question
		return test
	compileTest: (test, settings, cb) ->
		obj =
			test: @sanitize test
			settings: settings
		template = fs.readFileSync testTemplateFile
		template = handlebars.compile template.toString()


		tex = template obj
		texFile = path.join texFolder, test._id + '.tex'
		fs.writeFile texFile, tex, (err) ->
			if err
				cb err
			else
				cmd = 'pdflatex -jobname ' + test._id.toString() + ' -output-directory ' + pdfFolder + ' ' + texFile
				console.log cmd
				exec cmd, {timeout: 5000}, (err, stdout, stderr) ->
					if err
						cb err
					else
						pdfFile = path.join pdfFolder, 'test._id' + '.pdf'
						cb null, pdfFile