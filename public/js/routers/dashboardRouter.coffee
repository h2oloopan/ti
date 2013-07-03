define ['utils'], (utils) ->
    DashboardRouter = Backbone.Router.extend
        routes:
            'dashboard': 'dashboard'
        change: (view, options) ->
            options = options | {}
            require [view], (View) ->
                next = new View options
                next.render()
        dashboard: ->
            @change 'views/dashboard/index'
