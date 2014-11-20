define ['jquery', 'me', 'utils',
'ehbs!templates/admin/admin',
'ehbs!templates/admin/users',
'ehbs!templates/admin/users.new',
'ehbs!templates/admin/users.edit',
'ehbs!templates/admin/schools',
'ehbs!templates/admin/school.edit'
], ($, me, utils) ->
	AdminRoute = 
		setup: (App) ->
			App.Router.map ->
				@route 'admin'
				
			App.AdminRoute = Ember.Route.extend
				beforeModel: ->
					#check power
					thiz = @
					me.auth.power(999).then ->
						#done
						return true
					, (errors) ->
						#fail
						thiz.transitionTo 'error', {type: '401'}
				model: ->
					thiz = @
					return new Ember.RSVP.Promise (resolve, reject) ->
						new Ember.RSVP.hash
							users: thiz.store.find 'user'
							schools: thiz.store.find 'school'
						.then (result) ->
							resolve
								users: result.users
								schools: result.schools
						, (errors) ->
							reject errors

			App.AdminView = Ember.View.extend
				didInsertElement: ->
					@_super()
					$('.nav-tabs a').each (index) ->
						$(@).click (e) ->
							target = e.currentTarget
							option = $(target).attr('href').substr 1
							href = window.location.href
							if href.indexOf('?') >= 0 then href = href.substr 0, href.indexOf '?'
							window.location.href = href + '?' + option

					href = window.location.href
					href = if href.indexOf('?') >= 0 then '#' + href.substr(href.indexOf('?') + 1) else null
					if href?
						$('.nav-tabs a[href="' + href + '"]').click()
					else
						$('.nav-tabs a:first').click()

			App.UsersController = Ember.ArrayController.extend
				sortProperties: ['power']
				sortAscending: false
				itemController: 'user'
				actions:
					add: ->
						$('.modal-admin-user').modal()

			App.UserController = Ember.ObjectController.extend
				needs: 'usersEdit'
				isAdmin: ( ->
					return if @get('model.power') >= 999 then true else false
				).property 'power'
				type: ( ->
				).property 'power'
				actions:
					edit: (user) ->
						thiz = @
						user.set 'password', null
						@store.find('school').then (schools) ->
							#done
							thiz.set 'controllers.usersEdit.model',
								user: user
								schools: schools
							$('.modal-admin-user-edit').modal()
							return true
						, (errors) ->
							#fail
							return false
						return false
					delete: (user) ->
						ans = confirm 'Do you want to delete user ' + user.get('username') + '?'
						if ans
							#do something
							user.destroyRecord().then ->
								#done
								return true
							, (errors) ->
								#fail
								user.rollback()
								alert errors.responseText

						return false

			App.UsersEditController = Ember.ObjectController.extend
				roles: ['editor', 'instructor']
				errors: {}
				isAddingPrivilege: false
				cleanPrivilege: ->
					@set 'term', null
					@set 'subject', null
					@set 'course', null
				actions:
					addPrivilege: ->
						@set 'isAddingPrivilege', true 
						return false
					savePrivilege: ->
						if me.isEmptyString(@get('school')) and
						   me.isEmptyString(@get('term')) and 
						   me.isEmptyString(@get('subject')) and 
						   me.isEmptyString(@get('course'))
							alert 'Cannot enter an empty row of privilege'
							return false
						if me.isEmptyString(@get('subject')) and
						   !me.isEmptyString(@get('course'))
							alert 'Course must be coupled with subject'
							return false
						if me.isEmptyString(@get('course')) and
						   !me.isEmptyString(@get('subject'))
							alert 'Subject must be coupled with course'
							return false

						user = @get 'model'
						privileges = user.get 'privileges'
						privileges.pushObject
							school: @get 'school'
							term: @get 'term'
							subject: @get 'subject'
							course: @get 'course'
						user.set 'privileges', privileges
						@cleanPrivilege()
						@set 'isAddingPrivilege', false
						return false
					cancelPrivilege: ->
						@cleanPrivilege()
						@set 'isAddingPrivilege', false
						return false
					deletePrivilege: (privilege) ->
						privileges = @get 'user.privileges'
						privileges.removeObject privilege
						@set 'model.privileges', privileges
						return false
					save: (user) ->
						result = user.validate()
						keys = me.keys user.errors
						for key in keys
							if key != 'password'
								@set 'errors.' + key, errors[key]
								return false
						user.save().then ->
							#done
							$('.modal-admin-user-edit').modal 'hide'
						, (errors) ->
							#fail
							user.rollback()
							alert errors.responseText
						return false

			App.UsersNewController = Ember.ObjectController.extend
				user:
					role: {}
				roles: ['editor', 'instructor']
				prepare: (user) ->
					return user
				actions:
					add: ->
						@set 'user.errors', null
						user = @store.createRecord 'user', @get 'user'
						result = user.validate()
						if !result
							@set 'user.errors', user.errors
							return false
						user.save().then ->
							#done
							$('.modal-admin-user').modal 'hide'
						, (errors) ->
							#fail
							user.rollback()
							alert errors.responseText
						return false

			#schools
			App.SchoolsController = Ember.ArrayController.extend
				school: {}
				itemController: 'school'
				actions:
					add: (school) ->
						@set 'school.errors', null
						@set 'isAdding', true
						return false
					save: (school) ->
						thiz = @
						school = @store.createRecord 'school', school
						result = school.validate()
						if !result
							@set 'school.errors', school.errors
							return false
						school.save().then ->
							#done
							thiz.set 'school.name', null
							thiz.set 'isAdding', false
						, (errors) ->
							#fail
							school.rollback()
							alert errors.responseText
						return false
					cancel: ->
						@set 'school.name', null
						@set 'isAdding', false
						return false

			App.SchoolController = Ember.ObjectController.extend
				needs: 'schools'
				needs: 'schoolEdit'
				schoolEdit: Ember.computed.alias 'controllers.schoolEdit' 
				actions:
					select: (school) ->
						#ui
						id = school.get 'id'
						$('.nav-sidebar li').removeClass 'active'
						$('.nav-sidebar li[data-id="' + id + '"]').addClass 'active'
						@get('schoolEdit').send 'update', school

			App.SchoolEditController = Ember.ObjectController.extend
				selectedTermChange: ( ->
					if @get 'isReset'
						@set 'isReset', false
						return false
					if @get('selectedTerm.subjects')? && @get('selectedTerm.subjects').length > 0
						@set 'selectedSubject', @get('selectedTerm.subjects')[0]
					else
						@set 'selectedSubject', null
				).observes 'selectedTerm'
				actions:
					update: (school) ->
						@set 'model', school
						@set 'isEditing', true
						if @get('info.terms').length > 0
							@set 'selectedTerm', @get('info.terms')[0]
							if @get('selectedTerm.subjects').length > 0
								@set 'selectedSubject', @get('selectedTerm.subjects')[0]
					deleteSchool: (school) ->
						alert 'We are not allowed to delete school at the moment'
						return false
					addCourse: ->
						@set 'isAddingCourse', true
						return false
					cancelCourse: ->
						@set 'course', null
						@set 'isAddingCourse', false
						return false
					saveCourse: (course) ->
						thiz = @
						selectedTerm = @get 'selectedTerm'
						selectedSubject = @get 'selectedSubject'
						match = (item) ->
							if item.number.toLowerCase() == course.toLowerCase()
								return true
							else
								return false
						if selectedSubject.courses.any match
							alert 'You cannot add course with same name/number'
							return false
						selectedSubject.courses.pushObject
							number: course
							name: ''
						@set 'course', null
						@set 'isAddingCourse', false
						#async
						school = @get 'model'
						school.save().then ->
							#done
							found = school.get('info.terms').find (item) ->
								if item.name == selectedTerm.name then return true
								return false
							if !found? then return false
							thiz.set 'isReset', true
							thiz.set 'selectedTerm', found
							found = found.subjects.find (item) ->
								if item.name == selectedSubject.name then return true
								return false
							if !found? then return false
							thiz.set 'selectedSubject', found
							return true
						, (errors) ->
							#fail
							school.rollback()
							alert errors.responseText
						return false
					deleteCourse: (course) ->
						thiz = @
						ans = confirm 'Are you sure you want to delete course ' + course.number + '?'
						if !ans then return false
						selectedTerm = @get 'selectedTerm'
						selectedSubject = @get 'selectedSubject'
						selectedSubject.courses.removeObject course
						#async
						school = @get 'model'
						school.save().then ->
							#done
							found = school.get('info.terms').find (item) ->
								if item.name == selectedTerm.name then return true
								return false
							if !found? then return false
							found = found.subjects.find (item) ->
								if item.name == selectedSubject.name then return true
								return false
							if !found? then return false
							thiz.set 'selectedSubject', found
							return true
						, (errors) ->
							#fail
							school.rollback()
							alert errors.responseText
						return false
					addSubject: ->
						@set 'isAddingSubject', true
						return false
					cancelSubject: ->
						@set 'subject', null
						@set 'isAddingSubject', false
						return false
					saveSubject: (subject) ->
						thiz = @
						selectedTerm = @get 'selectedTerm'
						match = (item) ->
							if item.name.toLowerCase() == subject.toLowerCase()
								return true
							else
								return false
						if selectedTerm.subjects.any match
							alert 'You cannot add subject with same name'
							return false
						selectedTerm.subjects.pushObject
							name: subject
							courses: []
						@set 'subject', null
						@set 'isAddingSubject', false
						#async updating to server
						school = @get 'model'
						school.save().then ->
							#done
							found = school.get('info.terms').find (item) ->
								if item.name == selectedTerm.name then return true
								return false
							if !found? then return false
							thiz.set 'isReset', true
							thiz.set 'selectedTerm', found
							thiz.set 'selectedSubject', found.subjects[found.subjects.length - 1]
							return true
						, (errors) ->
							school.rollback()
							alert errors.responseText
						return false
					deleteSubject: (subject) ->
						ans = confirm 'Are you sure you want to delete subject ' + subject.name + '?'
						if !ans then return false
						selectedTerm = @get 'selectedTerm'
						selectedTerm.subjects.removeObject subject
						#async updating
						school = @get 'model'
						school.save().then ->
							#done
							found = school.get('info.terms').find (item) ->
								if item.name == selectedTerm.name then return true
								return false
							if !found? then return false
							thiz.set 'selectedTerm', found
							return true
						, (errors) ->
							school.rollback()
							alert errors.responseText
						return false
					addTerm: ->
						@set 'isAddingTerm', true
						return false
					cancelTerm: ->
						@set 'term', null
						@set 'isAddingTerm', false
						return false
					saveTerm: (term) ->
						thiz = @
						info = @get 'info'
						match = (item) ->
							if item.name.toLowerCase() == term.toLowerCase()
								return true
							else
								return false
						if info.terms.any match
							alert 'You cannot add term with same name'
							return false
						info.terms.pushObject
							name: term
							subjects: []
						@set 'term', null
						@set 'isAddingTerm', false
						#async
						school = @get 'model'
						school.save().then ->
							#done
							thiz.set 'selectedTerm', thiz.get('info.terms')[thiz.get('info.terms').length - 1]
							return true
						, (errors) ->
							school.rollback()
							alert errors.responseText
						return false
					deleteTerm: (term) ->
						thiz = @
						ans = confirm 'Are you sure you want to delete term ' + term.name + '?'
						if !ans then return false
						info = @get 'info'
						info.terms.removeObject term
						@set 'selectedTerm', null
						#async
						school = @get 'model'
						school.save().then ->
							#done
							return true
						, (errors) ->
							#fail
							school.rollback()
							alert errors.responseText
						return false


	return AdminRoute




