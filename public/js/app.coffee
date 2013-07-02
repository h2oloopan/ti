define ['routers/homeRouter', 'routers/accountRouter', 'routers/dashboardRouter', 'views/shared/header'],
(HomeRouter, AccountRouter, DashboardRouter, HeaderView) ->
    App =
        prerender: ->
            #render shared header and footer
            header = new HeaderView()
            header.render()
        initialize: ->
            #initialize routers
            new HomeRouter()
            new AccountRouter()
            #new DashboardRouter()
            Backbone.history.start()
            @prerender()
