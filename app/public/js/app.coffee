define ['me', 'routes/questionsRoute', 'routes/adminRoute',
'ehbs!templates/header', 'ehbs!templates/footer',
'ehbs!templates/login', 'ehbs!templates/signup'
], (me, QuestionsRoute, AdminRoute) ->
	app =
		start: ->
			App = Ember.Application.create()
			me.attach App, ['User', 'Question', 'School']
			
			App.Router.map ->
				@route 'login'
				@route 'signup'

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

			App.LoginRoute = Ember.Route.extend
				model: ->
					return @store.createRecord 'user', {}
				actions:
					login: ->
						thiz = @
						model = @controllerFor('login').get 'model'
						result = model.validate ['username', 'password']
						if !result then return false
						me.auth.login(model).then (user) ->
							#done
							thiz.controllerFor('application').set 'model', user
							thiz.transitionTo 'questions'
						, (errors) ->
							#fail
							alert errors
						
						return false

	return app					
