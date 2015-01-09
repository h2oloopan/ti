authorizer = module.exports =
	canAccessQuestion: (user, question) ->
		console.log question
		#admin can always access
		if user.power >= 999 then return true
		exist = (something) ->
			if something? && something.length > 0 then return true
			return false

		for privilege in user.privileges
			#console.log 'A'
			#console.log privilege.school
			#console.log question.school
			if exist(privilege.school) and privilege.school.trim().toLowerCase() != question.school.toString().trim().toLowerCase() then continue
			#console.log 'B'
			if exist(privilege.term) and privilege.term.trim().toLowerCase() != question.term.trim().toLowerCase() then continue
			#console.log 'C'
			if exist(privilege.subject) and privilege.subject.trim().toLowerCase() != question.subject.trim().toLowerCase() then continue
			#console.log 'D'
			if exist(privilege.course) and privilege.course.trim().toLowerCase() != question.course.trim().toLowerCase() then continue
			#console.log 'E'
			return true
		return false