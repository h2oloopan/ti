define ['views/shared/header', 'views/shared/admin/sidebar'], (HeaderView, SidebarView) ->
    AdminRouter = Backbone.Router.extend
        _view: null
        _header: new HeaderView()
        _sidebar: new SidebarView()
        routes:
            '': 'default'
            'index': 'index'
            'forums': 'forums'
        initialize: ->
            #test privilege
            router = @
            $.get('/api/account/auth/admin')
                .done ->
                    #ok
                    router._header.render()
                    router._sidebar.render()
                .fail ->
                    #redirect
                    window.location.href = '/'

        change: (view, options) ->
            if @_view?
                @_view.undelegateEvents()

            context = @
            require [view], (View) ->
                context._view = new View options
                context._view.render()
        default: ->
            @navigate 'index', {trigger: true, replace: true}
            @_sidebar.render()
        index: ->
            @change 'views/admin/index'
        forums: ->
            @change 'views/admin/forums'
