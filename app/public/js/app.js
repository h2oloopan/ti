// Generated by CoffeeScript 1.7.1
define(['me', 'routes/questionsRoute', 'routes/adminRoute', 'ehbs!templates/header', 'ehbs!templates/footer', 'ehbs!templates/login', 'ehbs!templates/signup'], function(me, QuestionsRoute, AdminRoute) {
  var app;
  app = {
    start: function() {
      var App;
      App = Ember.Application.create();
      me.attach(App, ['User', 'Question', 'School']);
      App.Router.map(function() {
        this.route('login');
        return this.route('signup');
      });
      QuestionsRoute.setup(App);
      AdminRoute.setup(App);
      App.ApplicationRoute = Ember.Route.extend({
        model: function() {
          return me.auth.check();
        },
        actions: {
          logout: function() {
            var thiz;
            thiz = this;
            me.auth.logout().then(function() {
              thiz.controllerFor('application').set('model', {});
              return thiz.transitionTo('index');
            }, function(errors) {
              return false;
            });
            return false;
          }
        }
      });
      App.ApplicationController = Ember.ObjectController.extend({
        isAdmin: (function() {
          var power;
          power = this.get('model.power');
          if (power >= 999) {
            return true;
          } else {
            return false;
          }
        }).property('model.power')
      });
      App.IndexRoute = Ember.Route.extend({
        beforeModel: function() {
          var thiz;
          thiz = this;
          return me.auth.check().then(function(user) {
            if (user != null) {
              return thiz.transitionTo('questions');
            } else {
              return thiz.transitionTo('login');
            }
          }, function(errors) {
            return thiz.transitionTo('login');
          });
        }
      });
      return App.LoginRoute = Ember.Route.extend({
        model: function() {
          return this.store.createRecord('user', {});
        },
        actions: {
          login: function() {
            var model, result, thiz;
            thiz = this;
            model = this.controllerFor('login').get('model');
            result = model.validate(['username', 'password']);
            if (!result) {
              return false;
            }
            me.auth.login(model).then(function(user) {
              thiz.controllerFor('application').set('model', user);
              return thiz.transitionTo('questions');
            }, function(errors) {
              return alert(errors);
            });
            return false;
          }
        }
      });
    }
  };
  return app;
});
