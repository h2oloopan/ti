// Generated by CoffeeScript 1.7.1
define(['me', 'routes/questionsRoute', 'routes/adminRoute', 'ehbs!templates/header', 'ehbs!templates/footer', 'ehbs!templates/login', 'ehbs!templates/signup', 'ehbs!templates/error'], function(me, QuestionsRoute, AdminRoute) {
  var app;
  app = {
    start: function() {
      var App;
      App = Ember.Application.create();
      me.attach(App, ['User', 'Question', 'School']);
      App['Count'] = DS.Model.extend({
        number: DS.attr()
      });
      App.Router.map(function() {
        this.route('login');
        this.route('signup');
        return this.route('error', {
          path: '/error/:type'
        });
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
      App.LoginRoute = Ember.Route.extend({
        model: function() {
          return this.store.createRecord('user', {});
        }
      });
      App.LoginController = Ember.ObjectController.extend({
        error: null,
        needs: 'application',
        actions: {
          login: function() {
            var result, thiz;
            thiz = this;
            this.set('error', null);
            result = this.get('model').validate(['username', 'password']);
            if (!result) {
              return false;
            }
            me.auth.login(this.get('model')).then(function(user) {
              thiz.store.unloadAll('question');
              thiz.store.unloadAll('school');
              thiz.set('controllers.application.model', user);
              return thiz.transitionToRoute('questions');
            }, function(errors) {
              thiz.set('error', errors);
              return false;
            });
            return false;
          }
        }
      });
      return App.ErrorController = Ember.ObjectController.extend({
        message: (function() {
          switch (this.get('type')) {
            case '401':
              return 'You do not have the permission to access the requested resource!';
            default:
              return 'Something went wrong!';
          }
        }).property('type')
      });
    }
  };
  return app;
});
