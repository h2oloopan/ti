require.config
    baseUrl: '/js/libs'
    paths:
        templates: '/templates'
        models: '/js/models'
        views: '/js/views'
        routers: '/js/routers'
        widgets: '/js/widgets'
        app: '/js/app'
    shim:
        'backbone': ['underscore', 'jquery']
        'bootstrap': ['jquery']
        'jquery.cookie': ['jquery']
        'utils': ['jquery', 'jquery.cookie', 'backbone']
        'app': ['backbone', 'bootstrap', 'utils']

require ['app'], (app) ->
    app.initialize()
