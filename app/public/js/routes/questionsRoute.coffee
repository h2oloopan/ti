define ['jquery', 'me'], ($, me) ->
	QuestionsRoute = 
		setup: (App) ->
			#route
			App.Router.map ->
				@resource 'questions'

	return QuestionsRoute