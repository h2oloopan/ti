define ['text!templates/dashboard/index.html', 'models/User', 'widgets/addGoal'], (template, User, AddGoalWidget) ->
    IndexView = Backbone.View.extend
        el: $('#content')
        events:
            'click .btn-add-goal': 'addGoal'
        addGoalWidget: null
        render: ->
            @model = new User()
            @model.url = @model.urlRoot + '/self'
            @model.on 'change', @onModelChange, @
            @model.fetch()
        onModelChange: ->
            @$el.html _.template(template, @model.toJSON())
        addGoal: ->
            @addGoalWidget = new AddGoalWidget($('#widget_add_goal'))
            @addGoalWidget.render()
