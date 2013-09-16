// Generated by CoffeeScript 1.6.3
(function() {
  define(['text!templates/dashboard/index.html', 'models/User', 'widgets/addGoal', 'widgets/profile'], function(template, User, WidgetAddGoal, WidgetProfile) {
    var IndexView;
    return IndexView = Backbone.View.extend({
      el: $('#content'),
      events: {
        'click .btn-add-goal': 'addGoal'
      },
      widgets: {
        wAddGoal: null,
        wProfile: null
      },
      render: function() {
        this.model = new User();
        this.model.url = this.model.urlRoot + '/self';
        this.model.on('change', this.onModelChange, this);
        return this.model.fetch();
      },
      onModelChange: function() {
        this.$el.html(_.template(template, this.model.toJSON()));
        this.widgets.wProfile = new WidgetProfile($('#widget_profile'), this.model);
        return this.widgets.wProfile.render();
      },
      addGoal: function() {
        if (!this.widgets.wAddGoal) {
          this.widgets.wAddGoal = new WidgetAddGoal($('#widget_add_goal'));
        }
        return this.widgets.wAddGoal.render();
      }
    });
  });

}).call(this);
