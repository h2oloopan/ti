define ['utils', 'text!templates/shared/header.html'], (utils, template) ->
    HeaderView = Backbone.View.extend
        el: $('#header')
        events:
            'click .btn-logout': 'logout'
            'click .btn-login': 'login'
            'click .btn-signup': 'signup'
        render: ->
            element = @$el
            utils.auth (result) ->
                model =
                    auth: result
                element.html _.template(template, model)
        logout: ->
            utils.logout (err) ->
                window.location.replace '/'
        login: ->
            utils.navigate 'account/login'
        signup: ->
            utils.navigate 'account/signup'

