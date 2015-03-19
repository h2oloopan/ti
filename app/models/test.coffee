me = require 'mongo-ember'
Schema = me.Schema

module.exports = 
	Test:
		schema:
			name:
				type: String
				required: true
			questions:
				type: [ Schema.Types.Mixed ]
				default: []
			note:
				type: String
			public:
				type: Boolean
				default: false
			school:
				type: Schema.Types.ObjectId
				ref: 'School'
				required: true
			subject:
				type: String
				required: true
			course:
				type: String
				required: true
			creator:
				type: Schema.Types.ObjectId
				ref: 'User'
			createdTime:
				type: Date
				default: null
			lastModifiedTime:
				type: Date
				default: null

		validationMessages:
			name:
				required: 'Name cannot be empty'
			school:
				required: 'School cannot be empty'
			subject:
				required: 'subject cannot be empty'
			course:
				required: 'course cannot be empty'
