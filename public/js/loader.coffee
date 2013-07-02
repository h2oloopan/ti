require.config
    baseUrl: '/js/libs'
    paths:
        templates: '/templates'
        models: '/js/models'
        views: '/js/views'
        routers: '/js/routers'
        app: '/js/app'
    shim:
        'backbone': ['underscore', 'jquery']
        'bootstrap': ['jquery']
        'utils': ['jquery', 'backbone']
        'app': ['backbone', 'bootstrap', 'utils']

require ['app'], (app) ->
    app.initialize()
