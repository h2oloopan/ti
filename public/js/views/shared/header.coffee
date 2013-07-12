define ['utils', 'text!templates/shared/header.html'], (utils, template) ->
    HeaderView = Backbone.View.extend
        el: $('#header')
        events:
            'click .btn-logout': 'logout'
            'click .btn-login': 'login'
            'click .btn-signup': 'signup'
        initialize: ->
            view = @
            utils.onNavigate ->
                view.render()
        render: ->
            element = @$el
            model =
                auth: utils.auth()
            element.html _.template(template, model)
        logout: ->
            utils.logout (err) ->
                utils.navigate '/'
        login: ->
            utils.navigate 'account/login'
        signup: ->
            utils.navigate 'account/signup'

