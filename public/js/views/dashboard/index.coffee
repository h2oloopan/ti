define ['text!templates/dashboard/index.html', 'models/User'], (template, User) ->
    IndexView = Backbone.View.extend
        el: $('#content')
        render: ->
            @model = new User()
            @model.url = @model.urlRoot + '/self'
            @model.on 'change', @onModelChange, @
            @model.fetch()
        onModelChange: ->
            @$el.html _.template(template, @model.toJSON())
            return false
