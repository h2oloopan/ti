require.config
	baseUrl: '/js/libs'
	ehbs:
		compile: true
		extension: '.html'
	paths:
		templates: '/templates'
		routes: '/js/routes'
		app: '/js/app'
	shim:
		'bootstrap': ['jquery']
		'ember': ['handlebars', 'jquery']
		'ember-data': ['ember']
		'app': ['ember', 'ember-data', 'bootstrap']

require ['app'], (app) ->
	app.start()
