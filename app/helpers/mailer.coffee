nm = require 'nodemailer'

transporter = nm.createTransport
	service: 'Gmail'
	auth:
		user: 'span@easyace.ca'
		pass: 'psy123321'


exports.sendMail = (to, subject, content, cb) ->
	options = 
		from: 'EasyAce'
		to: to
		subject: subject
		html: content

	transporter.sendMail options, cb

