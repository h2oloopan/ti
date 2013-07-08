define ['utils', 'text!templates/account/signup.html', 'models/user'], (utils, template, User) ->
    SignupView = Backbone.View.extend
        el: $('#content')
        events:
            'click .btn-signup': 'signup'
        initialize: ->
            @model = new User()
            @model.urlRoot = '/api/account/signup'
            @model.on 'invalid', (model, err) ->
                @error err
            , @

        render: ->
            @$el.html template

        signup: (e) ->
            @model.clear()
            @error()
            form = utils.serialize @$('form')
            if form.password != form.confirm
                @error 'Passwords do not match'
                return false

            if !form.agree?
                @error 'You must agree to terms of service and privacy policy'
                return false

            view = @
            @model.save form,
                success: ->
                    utils.navigate 'account/login?from=signup'
                error: (model, response) ->
                    view.error response.responseText

            return false

        error: (msg) ->
            if msg?
                @$('.warning-text').html msg
                @$('.warning-msg').show()
            else
                @$('.warning-msg').hide()

