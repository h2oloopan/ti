Schema = require('mongoose').Schema

module.exports =
	School:
		schema:
			name:
				type: String
				required: true
			info:
				type: Schema.Types.Mixed
				default: {}
			#info example, see configurations folder for real stuff
			#assume everything is string to cater to different schools
			###
			info: {
				subjects: [
					{
						name: 'Mathematics'
						code: 'MATH'
						terms: [
							{
								name: 'Fall 2014'
								code: '1149'
								classes: [
									name: 'Calculus 1 for Honours Math'
									number: '137'
								]
							}
						]
					}
				]
			}
			
			###

		validationMessages:
			name:
				required: 'School name cannot be empty'
