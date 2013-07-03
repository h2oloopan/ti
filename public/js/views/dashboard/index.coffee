define ['text!templates/dashboard/index.html'], (template) ->
    IndexView = Backbone.View.extend
        el: $('#content')
        render: ->
            @$el.html template