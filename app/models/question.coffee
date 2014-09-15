Schema = require('mongo-ember').Schema

module.exports = 
	Question:
		schema:
			question:
				type: String
				required: true
			hint:
				type: String
			answer:
				type: String
			#relationship
			school:
				type: Schema.Types.ObjectId
				ref: 'School'
		validationMessages:
			question:
				required: 'Question cannot be empty'
		
			

