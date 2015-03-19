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
