define ['text!templates/widgets/addgoal.html'], (template) ->
    AddGoalWidget = Backbone.View.extend
        el: $('#widget_add_goal')
        render: ->
            @$el.html template
        destroy: ->
            return false