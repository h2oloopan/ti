define ['text!templates/account/login.html', 'models/user'], (template, User) ->
    LoginView = Backbone.View.extend
        el: $('#content')
        events:
            'click .btn-login': 'login'
        initialize: ->
            @model = new User()
        render: ->
            @$el.html template
            @info()
            if @options.from == 'signup'
                @info '''<strong>Congratulations!</strong>
                         You have signed up successfully.
                         You can now log in with your new account.'''
        login: (e) ->
            @model.clear()
            @error()
            form = @$('form').serializeObject()
            @model.set form, {validate: true}

            if !@model.isValid()
                @error @model.validationError
                return false

            view = @
            $.post('/api/account/login', @model.toJSON())
                .done ->
                    window.location.href = '/'
                .fail (fb) ->
                    view.error fb.responseText

            return false

        error: (msg) ->
            if msg?
                @$('.warning-text').html msg
                @$('.warning-msg').show()
            else
                @$('.warning-msg').hide()

        info: (msg) ->
            if msg?
                @$('.info-msg').html msg
                @$('.info-msg').show()
            else
                @$('.info-msg').hide()
