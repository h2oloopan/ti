define ['utils'], (utils) ->
    AccountRouter = Backbone.Router.extend
        routes:
            'account/signup': 'signup'
            'account/login': 'login'
            'account/login?from=:from': 'login'
        change: (view, options) ->
            options = options || {}

            if options.auth? && utils.auth() != options.auth
                return false

            require [view], (View) ->
                next = new View options
                next.render()
        signup: ->
            @change 'views/account/signup',
                auth: false
        login: (from) ->
            if from?
                @change 'views/account/login',
                    from: from
                    auth: false
            else
                @change 'views/account/login',
                    auth: false
