define ['utils'], (utils) ->
    DashboardRouter = Backbone.Router.extend
        currentView: null
        routes:
            'dashboard': 'dashboard'
        change: (view, options) ->
            options = options | {}

            if @currentView?
                @currentView.undelegateEvents()

            require [view], (View) ->
                next = new View options
                @currentView = next
                @currentView.render()
        dashboard: ->
            @change 'views/dashboard/index'
