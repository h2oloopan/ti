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
			settings:
				type: Schema.Types.Mixed
				default: {}
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


		auth:
			#c
			c: (req, test, user, power, cb) ->
				if power > 0
					cb null
				else
					cb new Error 'You do not have the permission to access this'

			#r
			ro: (req, test, user, power, cb) ->
				if power > 0
					cb null
				else
					cb new Error 'You do not have the permission to access this'


			ra: (req, tests, user, power, cb) ->
				if power > 0
					cb null
				else
					cb new Error 'You do not have the permission to access this'


			#u
			u: (req, test, user, power, cb) ->
				if power > 0
					cb null
				else
					cb new Error 'You do not have the permission to access this'

			#d
			d: (req, test, user, power, cb) ->
				if power > 0
					cb null
				else
					cb new Error 'You do not have the permission to access this'



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


		api:
			ra: (req, res, model, form, names) ->
				ids = req.query.ids
				if ids? then ids = JSON.parse ids
				if ids? and Object.prototype.toString.call(ids) == '[object Array]'
					#is array
					model.find {_id: {$in: ids}}, (err, result) ->
						if err
							res.send 500, err.message
						else
							res.send 200, me.helper.wrap result, names.name
				else
					#regular one
					model.find {}, (err, result) ->
						if err
							res.send 500, err.message
						else
							res.send 200, me.helper.wrap result, names.cname
			#ro
###
			ro: (req, res, model, form, names) ->
				id = JSON.parse req.params.id
				if Object.prototype.toString.call(id) == '[object Array]'
					#is array
					model.find {_id: {$in: id}}, (err, result) ->
						if err
							res.send 500, err.message
						else
							res.send 200, me.helper.wrap result, names.cname
				else
					#single one
					model.findById id, (err, result) ->
						if err
							res.send 500, err.message
						else
							res.send 200, me.helper.wrap result, names.name
###
				



