module.exports =
	Goal:
		schema:
			title:
				type: String
				required: true
			progress:
				type: Number
				required: true
		validationMessages:
			title:
				required: 'Title cannot be empty'
			progress:
				required: 'Progress cannot be empty'