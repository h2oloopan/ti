// Generated by CoffeeScript 1.6.3
(function() {
  define(['text!templates/widgets/addgoal.html'], function(template) {
    var AddGoalWidget;
    return AddGoalWidget = Backbone.View.extend({
      initialize: function(el) {
        return this.setElement(el);
      },
      render: function() {
        return this.$el.html(template);
      },
      destroy: function() {
        return false;
      }
    });
  });

}).call(this);
