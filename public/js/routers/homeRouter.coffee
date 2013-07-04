define ['utils'], (utils) ->
    HomeRouter = Backbone.Router.extend
        routes:
            '': 'home'
        change: (view, options) ->
            options = options || {}
            require [view], (View) ->
                next = new View options
                next.render()
        home: ->
            if utils.auth()
                utils.navigate 'dashboard'
            else
                @change 'views/home/index'


