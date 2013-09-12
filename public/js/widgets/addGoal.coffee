define ['text!templates/widgets/addgoal.html'], (template) ->
    AddGoalWidget = Backbone.View.extend
        initialize: (el) ->
            @setElement el
        render: ->
            @$el.html template
        destroy: ->
            return false