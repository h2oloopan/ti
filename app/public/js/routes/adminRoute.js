// Generated by CoffeeScript 1.7.1
define(['jquery', 'me', 'utils', 'ehbs!templates/admin/admin', 'ehbs!templates/admin/users', 'ehbs!templates/admin/users.new', 'ehbs!templates/admin/schools'], function($, me, utils) {
  var AdminRoute;
  AdminRoute = {
    setup: function(App) {
      App.Router.map(function() {
        return this.route('admin');
      });
      App.AdminRoute = Ember.Route.extend({
        beforeModel: function() {
          var thiz;
          thiz = this;
          return me.auth.power(999).then(function() {
            return true;
          }, function(errors) {
            return thiz.transitionTo('error', {
              type: '401'
            });
          });
        },
        model: function() {
          var thiz;
          thiz = this;
          return new Ember.RSVP.Promise(function(resolve, reject) {
            return new Ember.RSVP.hash({
              users: thiz.store.find('user'),
              schools: thiz.store.find('school')
            }).then(function(result) {
              return resolve({
                users: result.users,
                schools: result.schools
              });
            }, function(errors) {
              return reject(errors);
            });
          });
        }
      });
      App.AdminView = Ember.View.extend({
        didInsertElement: function() {
          this._super();
          return $('.nav-tabs a:first').click();
        }
      });
      App.UsersController = Ember.ArrayController.extend({
        itemController: 'user',
        actions: {
          add: function() {
            return $('.modal-admin-user').modal();
          }
        }
      });
      App.UserController = Ember.ObjectController.extend({
        isAdmin: (function() {
          if (this.get('model.power') >= 999) {
            return true;
          } else {
            return false;
          }
        }).property('power'),
        type: (function() {}).property('power')
      });
      return App.UsersNewController = Ember.ObjectController.extend({
        user: {
          role: {}
        },
        roles: ['editor', 'instructor'],
        prepare: function(user) {
          return user;
        },
        actions: {
          add: function() {
            return alert(JSON.stringify(this.get('user')));
          }
        }
      });
    }
  };
  return AdminRoute;
});
