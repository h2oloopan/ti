define ['text!templates/shared/header.html',
    'models/user'],
    (template, User) ->
        HeaderView = Backbone.View.extend
            el: $('#header')
            events:
                'click .btn-logout': 'logout'
            initialize: ->
                @model = {}
            render: ->
                view = @
                $.get('/api/account/auth')
                    .done ->
                        view.model.auth = true
                    .fail ->
                        view.model.auth = false
                    .always ->
                        view.update()
            update: ->
                @$el.html _.template(template, @model)
            logout: (e) ->
                view = @
                $.post('/api/account/logout')
                    .always ->
                        window.location.reload()
