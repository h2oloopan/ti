module.exports =
	School:
		schema:
			name:
				type: String
				required: true
		validationMessages:
			name:
				required: 'School name cannot be empty'
