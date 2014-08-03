exports.init = (pe) ->
	pe.createModel 'User',
		username:
			type: String
			required: true
		password:
			type: String
			required: true
