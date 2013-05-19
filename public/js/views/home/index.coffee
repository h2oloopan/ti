define ['text!templates/home/index.html'], (template) ->
    IndexView = Backbone.View.extend
        el: $('#content')
        render: ->
            @$el.html template
