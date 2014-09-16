define ['jquery', 'me', '/js/MathJax/MathJax.js?config=TeX-AMS-MML_HTMLorMML'
'ehbs!templates/questions/questions.index',
'ehbs!templates/questions/questions.new'], 
($, me) ->
	QuestionsRoute = 
		setup: (App) ->
			me.attach App, ['Question', 'School']

			#route
			App.Router.map ->
				@resource 'questions', ->
					@route 'new'

			App.QuestionsRoute = Ember.Route.extend
				beforeModel: ->
					thiz = @
					me.auth.check().then (user) ->
						#done
						if !user?
							thiz.transitionTo 'login'
					, (errors) ->
						#fail
						thiz.transitionTo 'login'
				model: ->
					return @store.find 'question'

			App.QuestionsController = Ember.ArrayController.extend
				itemController: 'question'

			App.QuestionController = Ember.ObjectController.extend
				needs: 'questions'



			App.QuestionsNewRoute = Ember.Route.extend
				model: ->
					thiz = @
					return new Ember.RSVP.Promise (resolve, reject) ->
						new Ember.RSVP.hash
							question: thiz.store.createRecord 'question', {}
							schools: thiz.store.find 'school'
						.then (result) ->
							resolve
								question: result.question
								schools: result.schools
						, (errors) ->
							reject errors


			#m

			#v
			App.QuestionsNewView = Ember.View.extend
				didInsertElement: ->
					@_super()

					Preview = @controller.get 'Preview'
					Preview.init()
					Preview.callback = MathJax.Callback ['createPreview', Preview]
					Preview.callback.autoReset = true

					#bind keyup event to textarea
					$('#math-input').keyup ->
						Preview.update()

			#c
			App.QuestionsNewController = Ember.ObjectController.extend
				Preview:
					delay: 150
					preview: null
					buffer: null
					timeout: null
					mjRunning: false
					oldText: null
					init: ->
						@preview = document.getElementById 'math-preview'
						@buffer = document.getElementById 'math-buffer'
					swapBuffers: ->
						buffer = @preview
						preview = @buffer
						buffer.style.visibility = 'hidden'
						buffer.style.position = 'absolute'
						preview.style.position = ''
						preview.style.visibility = ''
					update: ->
						if @timeout then clearTimeout @timeout
						@timeout = setTimeout @callback, @delay
					createPreview: ->
						@timeout = null
						if @mjRunning then return
						text = document.getElementById('math-input').value
						if text == @oldtext then return
						@buffer.innerHTML = @oldtext = text
						@mjRunning = true
						MathJax.Hub.Queue ['Typeset', MathJax.Hub, @buffer], ['previewDone', @]
					previewDone: ->
						@mjRunning = false
						@swapBuffers()
				actions:
					add: ->
						thiz = @
						question = @get 'question'
						result = question.validate()
						if !result then return false
						question.save().then ->
							#done
							thiz.transitionToRoute 'questions'
						, (errors) ->
							#fail
							console.log errors
						return false
						

    		


	return QuestionsRoute