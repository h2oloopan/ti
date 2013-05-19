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
        'helpers': ['jquery']
        'app': ['backbone', 'bootstrap', 'helpers']

require ['app'], (app) ->
    app.initialize()

