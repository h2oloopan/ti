define ['jquery', 'me', 'utils',
'ehbs!templates/tests/tests.index',
'ehbs!templates/tests/tests.review',
'ehbs!templates/tests/tests.new'], ($, me, u) ->
	return TestsRoute = 
		setup: (App) ->
			#route
			App.Router.map ->
				@resource 'tests', ->
					@route 'new'
					@route 'review', 
						path: '/review/:tests'

			App.TestsReviewRoute = Ember.Route.extend
				model: (params) ->
					return @store.find 'test', params.tests