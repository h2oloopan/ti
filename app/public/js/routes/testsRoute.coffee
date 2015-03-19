define ['jquery', 'me', 'utils',
'ehbs!templates/tests/tests.index',
'ehbs!templates/tests/tests.new'], ($, me, u) ->
	return TestsRoute = 
		setup: (App) ->
			#route
			App.Router.map ->
				@resource 'tests', ->
					@route 'new'
					@route 'review'