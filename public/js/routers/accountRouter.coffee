define ['utils', 'views/shared/header'], (utils, HeaderView) ->
    AccountRouter = Backbone.Router.extend
        view: null
        header: null
        routes:
            'signup': 'signup'
            'login': 'login'
            'login?from=:from': 'login'
        change: (view, options) ->
            if !@header?
                @header = new HeaderView()
                @header.render()

            options = options || {}
            context = @
            require [view], (View) ->
                context.view = new View options
                context.view.render()
        signup: ->
            context = @
            utils.auth (result) ->
                if result
                    window.location.href = '/'
                else
                    @change 'views/account/signup', {router: @}
        login: (from) ->
            #if already logged in, just send back to home page
            context = @
            utils.auth (result) ->
                if result
                    window.location.href = '/'
                else
                    if from?
                        context.change 'views/account/login', {from: from}
                    else
                        context.change 'views/account/login'
