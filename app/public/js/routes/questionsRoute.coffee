define ['jquery', 'me',
'tinymce/tiny_mce',
'ehbs!templates/questions/questions.new'], 
($, me) ->
	QuestionsRoute = 
		setup: (App) ->
			#route
			App.Router.map ->
				@resource 'questions', ->
					@route 'new'


			#m

			#v
			App.QuestionsNewView = Ember.View.extend
				didInsertElement: ->
					@_super()
					tinyMCE.init
    					theme: 'advanced'
    					mode: 'textareas'
    					plugins: 'latex'
    					theme_advanced_buttons1: 'latex'
    					theme_advanced_buttons2: ''
    					theme_advanced_buttons3: ''


	return QuestionsRoute