define ['routers/adminRouter'], (AdminRouter) ->
    initialize = ->
        router = new AdminRouter
        Backbone.history.start()

    return {
        initialize: initialize
    }
