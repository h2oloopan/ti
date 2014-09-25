define ['me', 'routes/questionsRoute', 'routes/adminRoute',
'ehbs!templates/header', 'ehbs!templates/footer',
'ehbs!templates/login', 'ehbs!templates/signup',
'ehbs!templates/error'
], (me, QuestionsRoute, AdminRoute) ->
	app =
		start: ->
			App = Ember.Application.create()
			me.attach App, ['User', 'Question', 'School']
			
			App.Router.map ->
				@route 'login'
				@route 'signup'
				@route 'error', {path: '/error/:type'}

			QuestionsRoute.setup App
			AdminRoute.setup App

			App.ApplicationRoute = Ember.Route.extend
				model: ->
					return me.auth.check()
				actions:
					logout: ->
						thiz = @
						me.auth.logout().then ->
							#done
							thiz.controllerFor('application').set 'model', {}
							thiz.transitionTo 'index'
						, (errors) ->
							#fail
							return false
						return false

			App.ApplicationController = Ember.ObjectController.extend
				isAdmin: ( ->
					power = @get 'model.power'
					if power >= 999
						return true
					else
						return false
				).property 'model.power'

			App.IndexRoute = Ember.Route.extend
				beforeModel: ->
					thiz = @
					me.auth.check().then (user) ->
						#done
						if user?
							thiz.transitionTo 'questions'
						else
							thiz.transitionTo 'login'
					, (errors) ->
						#fail
						thiz.transitionTo 'login'

#login

			App.LoginRoute = Ember.Route.extend
				model: ->
					return @store.createRecord 'user', {}

			App.LoginController = Ember.ObjectController.extend
				error: null
				needs: 'application'
				actions:
					login: ->
						thiz = @
						@set 'error', null
						result = @get('model').validate ['username', 'password']
						if !result then return false
						me.auth.login(@get('model')).then (user) ->
							#done
							thiz.set 'controllers.application.model', user
							thiz.transitionTo 'questions'
						, (errors) ->
							#fail
							thiz.set 'error', errors
							return false
						
						return false
#error
			App.ErrorController = Ember.ObjectController.extend
				message: ( ->
					switch @get 'type'
						when '401'
							return 'You do not have the permission to access the requested resource!'
						else
							return 'Something went wrong!'
				).property 'type'



	return app					
