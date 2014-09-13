// Generated by CoffeeScript 1.7.1
define(['me', 'routes/questionsRoute', 'ehbs!templates/header', 'ehbs!templates/footer', 'ehbs!templates/login', 'ehbs!templates/signup'], function(me, QuestionsRoute) {
  var app;
  app = {
    start: function() {
      var App;
      App = Ember.Application.create();
      me.attach(App, ['User']);
      App.Router.map(function() {
        this.route('login');
        return this.route('signup');
      });
      QuestionsRoute.setup(App);
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
              return thiz.transitionTo('questions');
            }, function(errors) {
              return alert(errors);
            });
            return false;
          }
        }
      });

      /*
      			App.ApplicationRoute = Ember.Route.extend
      				actions:
      					logout: ->
      						thiz = @
      						me.auth.logout().then ->
      							 *done
      							thiz.controllerFor('application').set 'model', {}
      						, (errors) ->
      							 *fail
      							return false
      						return false
      			
      			App.ApplicationController = Ember.Controller.extend
      				needs: 'index'
      				modelBinding: 'controllers.index.model'
      
      			App.IndexRoute = Ember.Route.extend
      				model: ->
      					return me.auth.check()
      
      			App.IndexController = Ember.Controller.extend {}
      
      			 *login
      			App.LoginRoute = Ember.Route.extend
      				model: ->
      					return @store.createRecord 'user', {}
      				actions:
      					login: ->
      						thiz = @
      						model = @controllerFor('login').get 'model'
      						result = model.validate ['username', 'password']
      						if !result then return false
      						me.auth.login(model).then (user) ->
      							 *done
      							thiz.transitionTo 'index'
      						, (errors) ->
      							 *fail
      							alert errors
      						
      						return false
      
      			 *signup
      			App.SignupRoute = Ember.Route.extend
      				model: ->
      					return @store.createRecord 'user', {}
      
      			App.SignupController = Ember.ObjectController.extend
      				actions:
      					signup: ->
      						thiz = @
      						result = @get('model').validate()
      						if !result then return false
      
      						 *password confirmation should be checked here
      						if @get('confirm') != @get('password')
      							@set 'model.errors.confirm', 'Passwords do not match'
      							return false
      
      						me.auth.signup(@get('model')).then ->
      							 *done
      							thiz.transitionToRoute 'login'
      						, (errors) ->
      							 *fail
      							alert errors
      						return false
       */
    }
  };
  return app;
});
