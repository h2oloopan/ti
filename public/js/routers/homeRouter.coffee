define [], () ->
    HomeRouter = Backbone.Router.extend
        routes:
            '': 'home'
        change: (view, options) ->
            options = options || {}
            require [view], (View) ->
                next = new View options
                next.render()
        home: ->
            @change 'views/home/index'


