define ['text!templates/dashboard/index.html', 'models/User'], (template, User) ->
    IndexView = Backbone.View.extend
        el: $('#content')
        initialize: ->
            #bind model
            @model = new User()
            @model.url = @model.urlRoot + '/self'
            @model.on 'change', @onModelChange
            @model.fetch()
        render: ->
            @$el.html template
        onModelChange: (user) ->
            return false
