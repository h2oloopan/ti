// Generated by CoffeeScript 1.7.1
define(['me'], function(me) {
  var app;
  app = {
    start: function() {
      var App;
      App = Ember.Application.create();
      me.attach(App, ['User']);
      App.IndexRoute = Ember.Route.extend({
        model: function() {
          return this.store.find('user', '53e04e98be48a31a59bcd233');
        }
      });
      return false;
    }
  };
  return app;
});