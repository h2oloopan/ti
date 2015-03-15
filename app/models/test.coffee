me = require 'mongo-ember'
Schema = me.Schema

module.exports = 
	Test:
		schema:
			questions:
				type: [ Schema.Types.Mixed ]
				default: []