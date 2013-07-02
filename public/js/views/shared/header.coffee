define ['utils', 'text!templates/shared/header.html'], (utils, template) ->
    HeaderView = Backbone.View.extend
        el: $('#header')
        events:
            'click .btn-logout': 'logout'
        render: ->
            element = @$el
            utils.auth (result) ->
                model =
                    auth: result
                element.html _.template(template, model)
        logout: ->
            utils.logout (err) ->
                window.location.href '/'

