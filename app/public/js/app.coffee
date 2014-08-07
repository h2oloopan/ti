define ['me',
'ehbs!templates/header', 'ehbs!templates/footer',
'ehbs!templates/index', 'ehbs!templates/login', 'ehbs!templates/signup'
], (me) ->
	app =
		start: ->
			App = Ember.Application.create()
			me.attach App, ['User']
			
			App.Router.map ->
				@route 'login'
				@route 'signup'

			App.ApplicationRoute = Ember.Route.extend
				model: ->
					return me.auth.check()
				actions:
					logout: ->
						thiz = @
						me.auth.logout().then ->
							#done
							thiz.controllerFor('application').set 'model', null
						, (errors) ->
							#fail
							return false
						return false

			App.IndexController = Ember.ObjectController.extend
				needs: 'application'
				modelBinding: 'controllers.application.model'

			#login
			App.LoginRoute = Ember.Route.extend
				model: ->
					return @store.createRecord 'user', {}

			App.LoginController = Ember.ObjectController.extend
				needs: 'application'
				actions:
					login: ->
						thiz = @
						result = @get('model').validate ['username', 'password']
						if !result then return false
						me.auth.login(@get('model')).then (user) ->
							#done
							controller = thiz.get 'controllers.application'
							controller.set 'model', user
							thiz.transitionToRoute 'index'
						, (errors) ->
							#fail
							alert errors
						
						return false

			#signup
			App.SignupRoute = Ember.Route.extend
				model: ->
					return @store.createRecord 'user', {}

			App.SignupController = Ember.ObjectController.extend
				actions:
					signup: ->
						thiz = @
						result = @get('model').validate()
						if !result then return false

						#password confirmation should be checked here
						if @get('confirm') != @get('password')
							@set 'model.errors.confirm', 'Passwords do not match'
							return false

						me.auth.signup(@get('model')).then ->
							#done
							thiz.transitionToRoute 'login'
						, (errors) ->
							#fail
							alert errors
						return false
						


	return app					
