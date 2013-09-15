define ['text!templates/widgets/addgoal.html'], (template) ->
    WidgetAddGoal = Backbone.View.extend
        initialize: (el) ->
            @setElement el
        render: ->
            @$el.html template