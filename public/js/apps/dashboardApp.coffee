define ['routers/dashboardRouter'], (DashboardRouter) ->
    initialize = ->
        router = new DashboardRouter()
        Backbone.history.start()

    return {
        initialize: initialize
    }
