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
				tabs: (->
					tests = @get 'model'
					if !tests? then return []
					tabs = []
					counter = 0
					match = ['A', 'B', 'C']
					for i in [0...tests.get('length')]
						tab = 
							name: 'Test ' + match[counter]
							id: 't-' + match[counter]
							link: '#t-' + match[counter] 
							test: tests.content[counter]
							active: false
						if counter == 0 then tab.active = true
						tabs.push tab
						counter++
					return tabs
				).property 'model'

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