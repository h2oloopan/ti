define ['views/shared/header'],
    (HeaderView) ->
        AccountRouter = Backbone.Router.extend
            _view: null
            _header: null
            routes:
                'signup': 'signup'
                'login': 'login'
                'login?from=:from': 'login'
            change: (view, options) ->
                if !@_header?
                    @_header = new HeaderView()
                    @_header.render()

                options = options || {}
                context = @
                require [view], (View) ->
                    context._view = new View options
                    context._view.render()
            signup: ->
                @change 'views/account/signup', {router: @}
            login: (from) ->
                #if already logged in, just send back to home page
                context = @
                $.get('/api/account/auth')
                    .done ->
                        window.location.href = '/'
                    .fail ->
                        if from?
                            context.change 'views/account/login', {from: from}
                        else
                            context.change 'views/account/login'
