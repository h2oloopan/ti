module.exports =
	User:
		schema:
			username:
				type: String
				required: true
				match: /^[A-Z0-9\._-]+$/i
			password:
				type: String
				required: true
			firstName:
				type: String
				required: true
			lastName:
				type: String
				required: true