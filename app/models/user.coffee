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

		validationMessages:
			username:
				required: 'Username cannot be empty'
				match: 'Invalid username'
			password:
				required: 'Password cannot be empty'
			firstName:
				required: 'First name cannot be empty'
			lastName:
				required: 'Last name cannot be empty'