define ['routers/homeRouter'], (HomeRouter) ->
    initialize = ->
        router = new HomeRouter()
        Backbone.history.start()

    return {
        initialize: initialize
    }
