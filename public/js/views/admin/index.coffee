define ['text!templates/admin/index.html', 'models/dummy'], (template, Dummy) ->
    IndexView = Backbone.View.extend
        el: $('#content')
        initialize: ->
            @model = new Dummy()
            @model.url = '/api/admin/info'
        render: ->
            @model.on 'change', @onModelChange, @
            @model.fetch()
        onModelChange: ->
            @$el.html _.template template, @model.toJSON()
