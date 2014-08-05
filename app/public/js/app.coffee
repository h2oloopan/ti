define ['me'], (me) ->
	app =
		start: ->
			App = Ember.Application.create()
			me.attach App, ['User']
			
			App.IndexRoute = Ember.Route.extend
				model: ->
					return @store.find 'user', '53e04e98be48a31a59bcd233'



			return false


	return app