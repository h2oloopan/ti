define ['routers/accountRouter'], (AccountRouter) ->
    initialize = ->
        router = new AccountRouter
        Backbone.history.start()

    return {
        initialize: initialize
    }
