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
			summary:
				type: String
			tags:
				type: [String]
			difficulty: 
				type: Number
			#flag is used to mark the state of the question
			#e.g. it may be marked to delete but we will not
			#remove it from database directly
			flag:
				type: Number

			#relationship
			school:
				type: Schema.Types.ObjectId
				ref: 'School'
			subject:
				type: String
			term:
				type: String
			course:
				type: String

		validationMessages:
			question:
				required: 'Question cannot be empty'
		
			

