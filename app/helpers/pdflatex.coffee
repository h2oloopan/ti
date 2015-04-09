sys = require 'sys'
spawn = require('child_process').spawn
handlebars = require 'handlebars'
path = require 'path'
fs = require 'fs'
pdfFolder = path.resolve 'temp/pdfs'
texFolder = path.resolve 'temp/texs'
templateFolder = path.resolve 'templates'

testTemplateFile = path.join templateFolder, 'test.hbs'

pdflatex = module.exports =
	compileTest: (test, settings, cb) ->
		obj =
			test: test
			settings: settings
		template = fs.readFileSync testTemplateFile
		template = handlebars.compile template.toString()
		tex = template obj
		texFile = path.join texFolder, test._id + '.tex'
		fs.writeFile texFile, tex, (err) ->
			if err
				cb err
			else
				process = spawn 'pdflatex', ['-job-name', test._id, '-output-directory', folder, texFile]
				process.on 'exit', (code) ->
					pdfFile = path.join pdfFolder, 'test._id' + '.pdf'
					cb null, pdfFile
				process.on 'error', (err) ->
					cb err