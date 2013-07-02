define ['views/shared/header'], (HeaderView) ->
    HomeRouter = Backbone.Router.extend
        view: null
        header: null
        routes:
            '': 'index'
        change: (view, options) ->
            options = options || {}
            if !@header?
                @header = new HeaderView
                @header.render()

            context = @
            require [view], (View) ->
                context.view = new View options
                context.view.render()
        index: ->
            @change 'views/home/index'


