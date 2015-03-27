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
					@route 'review'

			App.TestsReviewRoute = Ember.Route.extend
				queryParams:
					tests:
						refreshModel: true
						replace: true
				model: (params) ->
					return @store.find 'test', {ids: params.tests}

			App.TestsReviewController = Ember.ArrayController.extend
				queryParams: ['tests']
				actions:
					switch: (test) ->
						return false
					save: ->
						return false
###
			App.TestsReviewController = Ember.ArrayController.extend
				itemController: 'testReview'
				actions:
					switch: (test) ->
						return false
					save: ->
						return false

			App.TestReviewController = Ember.ObjectController.extend
				needs: 'testsReview'
###