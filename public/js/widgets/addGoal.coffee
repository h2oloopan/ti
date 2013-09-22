define ['text!templates/widgets/addgoal.html'], (template) ->
    WidgetAddGoal = Backbone.View.extend
        events:
            'click .btn-goal-save': 'goalSave'
            'click .btn-goal-cancel' : 'goalCancel'
        initialize: (el) ->
            @setElement el
        render: ->
            @$el.html template
        goalSave: ->
            #save goal to server
            alert 'save'
            return false
        goalCancel: ->
            #cancel, hide the widget
            alert 'cancel'
            return false