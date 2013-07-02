define ['routers/homeRouter'], (HomeRouter) ->
    App =
        initialize: ->
            router = new HomeRouter
            Backbone.history.start()
