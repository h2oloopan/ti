define ['jquery', 'me', '/js/MathJax/MathJax.js?config=TeX-AMS-MML_HTMLorMML'
'ehbs!templates/questions/questions.index',
'ehbs!templates/questions/questions.new'], 
($, me) ->
	QuestionsRoute = 
		setup: (App) ->
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


			#m

			#v
			
			App.QuestionsNewController = Ember.ObjectController.extend
				didInsertElement: ->
					@_super()
					Preview = 
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
							Preview.timeout = null
							if @mjRunning then return
							text = document.getElementById('math-input').value
							if text == @oldtext then return
							@buffer.innerHTML = @oldtext = text
							@mjRunning = true
							MathJax.Hub.Queue ['Typeset', MathJax.Hub, @buffer], ['previewDone', @]
						previewDone: ->
							@mjRunning = false
							@swapBuffers()

					Preview.callback = MathJax.Callback ['createPreview', Preview]
					Preview.callback.autoReset = true

    		


	return QuestionsRoute