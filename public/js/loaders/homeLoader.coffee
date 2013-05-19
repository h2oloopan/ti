require.config
    baseUrl: '/js/libs'
    paths:
        templates: '/templates'
        models: '/js/models'
        views: '/js/views'
        routers: '/js/routers'
        app: '/js/apps/homeApp'
    shim:
        'backbone': ['underscore', 'jquery']
        'bootstrap': ['jquery']
        'app': ['backbone', 'bootstrap']

require ['app'], (app) ->
    app.initialize()
