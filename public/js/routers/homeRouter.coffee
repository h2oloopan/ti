define ['utils'], (utils) ->
    HomeRouter = Backbone.Router.extend
        currentView: null
        routes:
            '': 'home'
        change: (view, options) ->
            options = options || {}

            if @currentView?
                @currentView.undelegateEvents()

            require [view], (View) ->
                next = new View options
                @currentView = next
                @currentView.render()
        home: ->
            if utils.auth()
                utils.navigate 'dashboard'
            else
                @change 'views/home/index'


