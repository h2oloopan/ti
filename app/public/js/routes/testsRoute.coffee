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

			App.TestsIndexRoute = Ember.Route.extend
				model: ->
					return @store.find 'test'

			App.TestsIndexController = Ember.ArrayController.extend
				sortProperties: ['id']
				sortAscending: false
				itemController: 'testItem'

			App.TestItemController = Ember.ObjectController.extend
				downloadPath: (->
					return '/api/download/pdfs/' + @get 'id'
				).property 'model'
				actions:
					republish: (test) ->
						test.set 'public', true
						test.save().then (result) ->
							#done
							return true #do nothing
						, (errors) ->
							alert errors.responseText
							return false
						return false
					review: (test) ->
						id = test.get 'id'
						a = [id]
						@transitionToRoute 'tests.review',
							queryParams:
								tests: JSON.stringify a
						return false

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
						tab.test.downloadPath = '/api/download/pdfs/' + tab.test.get('id')
						if counter == 0 then tab.active = true
						if counter == 0 then @send 'switch', tests.content[counter]
						tabs.push tab
						counter++
					return tabs
				).property 'model'
				actions:
					switch: (test) ->
						@set 'test', test
						@set 'settings', JSON.stringify test.get('settings')
						return false
					save: ->
						return false
					publish: (test) ->
						thiz = @
						settings = @get 'settings'
						if !settings?
							settings = {}
						else
							try
								settings = JSON.parse settings
							catch err
								alert 'Invalid setting format, must be JSON'
								return false
						test.set 'settings', settings
						test.set 'public', true
						test.save().then (result) ->
							#done
							#do nothing here
							return true
						, (errors) ->
							#fail
							alert errors.responseText
							return false

						return false

			App.QuestionItemView = Ember.View.extend
				didInsertElement: ->
					@_super()
					element = @get('element')
					MathJax.Hub.Queue ['Typeset', MathJax.Hub, element]
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