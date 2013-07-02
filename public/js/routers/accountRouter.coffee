define ['utils'], (utils) ->
    AccountRouter = Backbone.Router.extend
        routes:
            'account/signup': 'signup'
            'account/login': 'login'
            'account/login?from=:from': 'login'
        change: (view, options) ->
            options = options || {}
            require [view], (View) ->
                next = new View options
                next.render()
        signup: ->
            router = @
            utils.auth (result) ->
                if result
                    window.location.href = '/'
                else
                    router.change 'views/account/signup', {router: router}
        login: (from) ->
            #if already logged in, just send back to home page
            router = @
            utils.auth (result) ->
                if result
                    window.location.href = '/'
                else
                    if from?
                        router.change 'views/account/login', {from: from}
                    else
                        router.change 'views/account/login'
