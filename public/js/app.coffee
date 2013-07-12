define ['routers/homeRouter', 'routers/accountRouter', 'routers/dashboardRouter',
        'views/shared/header', 'views/shared/footer'],
(HomeRouter, AccountRouter, DashboardRouter, HeaderView, FooterView) ->
    App =
        prerender: ->
            #render shared header and footer
            header = new HeaderView()
            footer = new FooterView()
            header.render()
            footer.render()
        initialize: ->
            #initialize routers
            new HomeRouter()
            new AccountRouter()
            new DashboardRouter()
            Backbone.history.start()
            @prerender()
