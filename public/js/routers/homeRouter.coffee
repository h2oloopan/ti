define ['views/home/index', 'views/shared/header'],
(IndexView, HeaderView) ->
    HomeRouter = Backbone.Router.extend
        routes:
            '': 'index'
        initialize: ->
            header = new HeaderView()
            header.render()
        index: ->
            indexView = new IndexView()
            indexView.render()



