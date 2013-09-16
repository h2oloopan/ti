define ['text!templates/widgets/profile.html'], (template) ->
    WidgetProfile = Backbone.View.extend
        initialize: (el, model) ->
            @setElement el
            @model = model
        render: ->
            @$el.html _.template(template, @model.toJSON())