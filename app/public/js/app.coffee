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

			App.IndexRoute = Ember.Route.extend
				model: ->
					return me.auth.check()

			#login
			App.LoginRoute = Ember.Route.extend
				model: ->
					return @store.createRecord 'user', {}

			App.LoginController = Ember.ObjectController.extend
				actions:
					login: ->
						me.auth.login(@get('model')).then ->
							#done
							return true
						, (errors) ->
							console.log errors
							#fail
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
