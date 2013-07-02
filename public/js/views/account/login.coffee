define ['utils', 'text!templates/account/login.html', 'models/user'], (utils, template, User) ->
    LoginView = Backbone.View.extend
        el: $('#content')
        events:
            'click .btn-login': 'login'
        render: ->
            @$el.html template
            @info()
            if @options.from == 'signup'
                @info '''<strong>Congratulations!</strong>
                         You have signed up successfully.
                         You can now log in with your new account.'''
        login: (e) ->
            @error()
            form = utils.serialize @$('form')
            user = new User()
            user.set form, {validate: true}

            if !user.isValid()
                @error user.validationError
                return false

            view = @
            utils.login user.toJSON(), (err) ->
                if err?
                    view.error err

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
