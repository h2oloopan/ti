define ['jquery', 'me', 'utils',
'ehbs!templates/admin/admin',
'ehbs!templates/admin/users',
'ehbs!templates/admin/users.new',
'ehbs!templates/admin/users.edit',
'ehbs!templates/admin/rendering',
'ehbs!templates/admin/schools',
'ehbs!templates/admin/school.edit',
'ehbs!templates/admin/console'], ($, me, utils) ->
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
							template: $.getJSON '/api/edit/tests/template'
						.then (result) ->
							resolve
								users: result.users
								schools: result.schools
								template: result.template.text
						, (errors) ->
							reject errors

			App.AdminController = Ember.ObjectController.extend
				actions:
					deleteQuestionPhoto: ->
						$.ajax
							url: '/api/images/temp'
							type: 'DELETE'
						.done (result) ->
							return false #do nothing
						.fail (response) ->
							alert response.responseText

						return false

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


			Ember.Handlebars.helper 'school', (value, options) ->
				return new Ember.Handlebars

			App.UsersEditController = Ember.ObjectController.extend
				roles: ['editor', 'instructor']
				errors: {}
				isAddingPrivilege: false
				schoolChanged: ( -> 
					if @get('user')
						privileges = @get 'user.privileges'
						for privilege in privileges
							@store.find 'school', privilege.school
							.then (result) ->
								#done
								privilege.schoolDisplay = result.get 'name'
								return true
							, (errors) ->
								#fail
								return false
				).observes 'user'

				cleanPrivilege: ->
					@set 'subject', null
					@set 'course', null
				actions:
					addPrivilege: ->
						@set 'isAddingPrivilege', true 
						return false
					savePrivilege: ->
						if !@get('school')? and
						   me.isEmptyString(@get('subject')) and 
						   me.isEmptyString(@get('course'))
							alert 'Cannot enter an empty row of privilege'
							return false
						if me.isEmptyString(@get('subject')) and
						   !me.isEmptyString(@get('course'))
							alert 'Course must be coupled with subject'
							return false

						user = @get 'user'
						privileges = user.get 'privileges'
						privileges.pushObject
							school: @get 'school'
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
						@set 'user.privileges', privileges
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


			#console
			App.ConsoleController = Ember.ObjectController.extend
				url: ''
				stuff: ''
				result: ''
				actions:
					post: ->
						thiz = @
						url = @get 'url'
						data = @get 'stuff'
						data = JSON.parse data.trim()
						$.ajax
							type: 'POST'
							url: url
							data: JSON.stringify data
							dataType: 'json'
							contentType: 'application/json; charset=utf-8'
						.done (result) ->
							thiz.set 'result', result
							return true
						.fail (response) ->
							thiz.set 'result', response.responseText
							return false
						return false


			#tests
			App.RenderingController = Ember.ObjectController.extend
				actions:
					save: ->
						thiz = @
						template = @get 'template'
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
				actions:
					update: (school) ->
						@set 'model', school
						@set 'isEditing', true
						if @get('info.subjects').length > 0
							@set 'selectedSubject', @get('info.subjects')[0]
					deleteSchool: (school) ->
						alert 'We are not allowed to delete school at the moment'
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
						info = @get 'info'
						match = (item) ->
							if item.name.toLowerCase() == subject.toLowerCase() then return true
							return false

						if info.subjects.any match
							alert 'You cannot add subject with same name'
							return false

						info.subjects.pushObject
							name: subject
							courses: []

						@set 'subject', null
						@set 'isAddingSubject', false
						#async updating to server
						school = @get 'model'
						school.save().then ->
							#done
							subjects = school.get('info.subjects')
							if subjects.length == 0 then return true
							thiz.set 'selectedSubject', subjects[subjects.length - 1]
							return true
						, (errors) ->
							school.rollback()
							alert errors.responseText
							return false
						return false
					deleteSubject: (subject) ->
						thiz = @
						ans = confirm 'Are you sure you want to delete subject ' + subject.name + '?'
						if !ans then return false
						info = @get 'info'
						info.subjects.removeObject subject
						#async updating
						school = @get 'model'
						school.save().then ->
							#done
							subjects = school.get('info.subjects')
							if subjects.length == 0 then return true
							thiz.set 'selectedSubject', subjects[subjects.length - 1]
							return true
						, (errors) ->
							school.rollback()
							alert errors.responseText
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
						selectedSubject = @get 'selectedSubject'
						match = (item) ->
							if item.number.toLowerCase() == course.toLowerCase() then return true
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
							found = school.get('info.subjects').find (item) ->
								if item.name == selectedSubject.name then return true
								return false

							if !found? then return true
							thiz.set 'selectedSubject', found
							return true
						, (errors) ->
							#fail
							school.rollback()
							alert errors.responseText
							return false
						return false
					deleteCourse: (course) ->
						thiz = @
						ans = confirm 'Are you sure you want to delete course ' + course.number + '?'
						if !ans then return false
						#selectedTerm = @get 'selectedTerm'
						selectedSubject = @get 'selectedSubject'
						selectedSubject.courses.removeObject course
						#async
						school = @get 'model'
						school.save().then ->
							#done
							found = school.get('info.subjects').find (item) ->
								if item.name == selectedSubject.name then return true
								return false
							if !found? then return true
							thiz.set 'selectedSubject', found
							return true
						, (errors) ->
							#fail
							school.rollback()
							alert errors.responseText
						return false
					addType: ->
						@set 'isAddingType', true
						return false
					cancelType: ->
						@set 'type', null
						@set 'isAddingType', false
						return false
					saveType: (type) ->
						thiz = @
						types = @get 'types'
						match = (item) ->
							if item.toLowerCase() == type.toLowerCase() then return true
							return false
						if types.any match
							alert 'You cannot add type with same name'
							return false
						types.pushObject type

						@set 'type', null
						@set 'isAddingType', false

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
					deleteType: (type) ->
						thiz = @
						ans = confirm 'Are you sure you want to delete type ' + type + '?'
						if !ans then return false
						types = @get 'types'
						types.removeObject type
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

					addTerm: ->
						@set 'isAddingTerm', true
						return false
					cancelTerm: ->
						@set 'term', null
						@set 'isAddingTerm', false
						return false
					saveTerm: (term) ->
						thiz = @
						terms = @get 'terms'
						match = (item) ->
							if item.toLowerCase() == term.toLowerCase() then return true
							return false
						if terms.any match
							alert 'You cannot add term with same name'
							return false
						terms.pushObject term

						@set 'term', null
						@set 'isAddingTerm', false
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
					deleteTerm: (term) ->
						thiz = @
						ans = confirm 'Are you sure you want to delete term ' + term + '?'
						if !ans then return false
						terms = @get 'terms'
						terms.removeObject term
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




