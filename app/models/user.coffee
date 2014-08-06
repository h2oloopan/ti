module.exports =
	User:
		schema:
			username:
				type: String
				required: true
			password:
				type: String
				required: true
			firstName:
				type: String
				required: true
			lastName:
				type: String
				required: true