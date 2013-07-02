define ['utils', 'text!templates/home/index.html'], (utils, template) ->
    IndexView = Backbone.View.extend
        el: $('#content')
        events:
            'click .btn-login': 'login'
            'click .btn-signup': 'signup'
        render: ->
            @$el.html template

        login: ->
            utils.navigate 'account/login'
        signup: ->
            utils.navigate 'account/signup'
