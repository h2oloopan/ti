nm = require 'nodemailer'
path = require 'path'
fs = require 'fs'
config = require '../config'

template_registration = path.resolve 'helpers/mailTemplates/registration.html'

transporter = nm.createTransport
	service: 'Gmail'
	auth:
		user: 'span@easyace.ca'
		pass: 'psy123321'


mailer = module.exports =
	sendMail: (to, subject, content, cb) ->
		options = 
			from: 'EasyAce'
			to: to
			subject: subject
			html: content

		transporter.sendMail options, cb
	sendRegistrationMail: (user, cb) ->
		prepare = (template) ->
			content = template.replace '{{username}}', user.username
				.replace '{{password}}', user.password
				.replace '{{url}}', config.url
			return content

		fs.readFile template_registration, (err, template) ->
			if err
				cb err
			else
				content = prepare template
				mailer.sendMail user.email, 'EasyAce Registration Completed', content, cb


