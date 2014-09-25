define ['jquery', 'me', 'utils',
'ehbs!templates/admin/admin',
'ehbs!templates/admin/users',
'ehbs!templates/admin/schools'
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
					$('.nav-tabs a:first').click() #click the first tab by default

			App.UsersController = Ember.ArrayController.extend
				itemController: 'user'

			App.UserController = Ember.ObjectController.extend
				type: ( ->
				).property 'role'






	return AdminRoute