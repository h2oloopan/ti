Schema = require('mongo-ember').Schema

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
			email:
				type: String
				required: true
				match: /^[A-Z0-9\._%+-]+@[A-Z0-9\.-]+\.[A-Z]{2,4}$/i
			power:
				type: Number
				default: 10
			role:
				type: Schema.Types.Mixed
				default: {}
		validationMessages:
			username:
				required: 'Username cannot be empty'
				match: 'Invalid username'
			password:
				required: 'Password cannot be empty'
			email:
				required: 'Email cannot be empty'
				match: 'Invalid email address'


