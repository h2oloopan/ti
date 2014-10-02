require.config
	baseUrl: '/js/libs'
	ehbs:
		compile: false
		extension: '.html'
	paths:
		templates: '/templates'
		routes: '/js/routes'
		app: '/js/app'
		mj: '/js/MathJax'
	shim:
		'bootstrap': ['jquery']
		'jquery.hotkeys': ['jquery']
		'bootstrap-wysiwyg': ['bootstrap', 'jquery', 'jquery.hotkeys']
		'ember': ['handlebars', 'jquery']
		'ember-data': ['ember']
		'app': ['ember', 'ember-data', 'bootstrap']

require ['app'], (app) ->
	app.start()
