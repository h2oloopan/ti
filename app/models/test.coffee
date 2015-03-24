me = require 'mongo-ember'
moment = require 'moment'
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
				default: ''
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


		before:
			#c
			c: (test, user, cb) ->
				if !user? then return cb new Error 'No user is present'
				time = moment().toDate()
				test.creator = me.ObjectId user._id
				test.createdTime = time
				test.lastModifiedTime = time

				for question in test.questions
					question._id = me.ObjectId question._id
					question.editor = me.ObjectId question.editor
					question.school = me.ObjectId question.school

				cb null, test





