authorizer = module.exports =
	canAccessQuestion: (user, question) ->
		for privilege in user.privileges
			if privilege.school? and privilege.school != question.school then continue
			if privilege.term? and privilege.term != question.term then continue
			if privilege.subject? and privilege.subject != question.subject then continue
			if privilege.course? and privilege.course != question.course then continue
			return true
		return false