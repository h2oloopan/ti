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

			return false


	return app