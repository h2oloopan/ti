define ['views/shared/header'], (HeaderView) ->
    DashboardRouter = Backbone.Router.extend
        view: null
        header: null
        routes:
            'dashboard': 'dashboard'
        change: (view, options) ->
            if !@_header?
                @_header = new HeaderView()
                @_header.render()

            options = options | {}
            context = @
            require [view], (View) ->
                context._view = new View options
                context._view.render()
        dashboard: ->
            @change 'views/dashboard/index'
