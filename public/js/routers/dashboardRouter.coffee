define ['views/shared/header'], (HeaderView) ->
    DashboardRouter = Backbone.Router.extend
        _view: null
        _header: null
        routes:
            '': 'index'
        change: (view, options) ->
            if !@_header?
                @_header = new HeaderView()
                @_header.render()

            options = options | {}
            context = @
            require [view], (View) ->
                context._view = new View options
                context._view.render()
        index: ->
            @change 'views/dashboard/index'
