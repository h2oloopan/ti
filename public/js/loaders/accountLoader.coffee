require.config
    baseUrl: '/js/libs'
    paths:
        templates: '/templates'
        models: '/js/models'
        views: '/js/views'
        routers: '/js/routers'
        app: '/js/apps/accountApp'
    shim:
        'backbone': ['underscore', 'jquery']
        'bootstrap': ['jquery']
        'utils': ['jquery']
        'app': ['backbone', 'bootstrap', 'utils']

require ['app'], (app) ->
    app.initialize()

