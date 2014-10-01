define ['jquery', 'me', 'utils',
'ehbs!templates/admin/admin',
'ehbs!templates/admin/users',
'ehbs!templates/admin/users.new',
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
				isAdmin: ( ->
					return if @get('model.power') >= 999 then true else false
				).property 'power'
				type: ( ->
				).property 'power'
				actions:
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
			App.SchoolsView = Ember.View.extend
				didInsertElement: ->
					@_super()
					$('.nav-sidebar a:first').click()

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
						@set 'selectedSubject', @get('info.subjects')[0]
						@set 'selectedTerm', @get('selectedSubject.terms')[0]
					selectSubject: ->

						return false
					addSubject: ->
						@set 'isAddingSubject', true
						return false
					cancelSubject: ->
						@set 'isAddingSubject', false
						return false
					saveSubject: (subject) ->
						info = @get 'info'
						info.subjects.pushObject
							name: subject
							code: subject
							terms: []
						@set 'info', info
						#@notifyPropertyChange 'model.info'
						@set 'isAddingSubject', false
						return false
					save: (school) ->






	return AdminRoute