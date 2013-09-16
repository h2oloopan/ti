define ['text!templates/dashboard/index.html', 'models/User', 'widgets/addGoal', 'widgets/profile'],
(template, User, WidgetAddGoal, WidgetProfile) ->
    IndexView = Backbone.View.extend
        el: $('#content')
        events:
            'click .btn-add-goal': 'addGoal'
        widgets:
            wAddGoal: null
            wProfile: null
        render: ->
            @model = new User()
            @model.url = @model.urlRoot + '/self'
            @model.on 'change', @onModelChange, @
            @model.fetch()
        onModelChange: ->
            @$el.html _.template(template, @model.toJSON())
            @widgets.wProfile = new WidgetProfile $('#widget_profile'), @model
            @widgets.wProfile.render()
        addGoal: ->
            if !@widgets.wAddGoal
                @widgets.wAddGoal = new WidgetAddGoal $('#widget_add_goal')
            @widgets.wAddGoal.render()
