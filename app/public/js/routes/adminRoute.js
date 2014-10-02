// Generated by CoffeeScript 1.7.1
define(['jquery', 'me', 'utils', 'ehbs!templates/admin/admin', 'ehbs!templates/admin/users', 'ehbs!templates/admin/users.new', 'ehbs!templates/admin/schools', 'ehbs!templates/admin/school.edit'], function($, me, utils) {
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
          var href;
          this._super();
          $('.nav-tabs a').each(function(index) {
            return $(this).click(function(e) {
              var href, option, target;
              target = e.currentTarget;
              option = $(target).attr('href').substr(1);
              href = window.location.href;
              if (href.indexOf('?') >= 0) {
                href = href.substr(0, href.indexOf('?'));
              }
              return window.location.href = href + '?' + option;
            });
          });
          href = window.location.href;
          href = href.indexOf('?') >= 0 ? '#' + href.substr(href.indexOf('?') + 1) : null;
          if (href != null) {
            return $('.nav-tabs a[href="' + href + '"]').click();
          } else {
            return $('.nav-tabs a:first').click();
          }
        }
      });
      App.UsersController = Ember.ArrayController.extend({
        sortProperties: ['power'],
        sortAscending: false,
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
        type: (function() {}).property('power'),
        actions: {
          "delete": function(user) {
            var ans;
            ans = confirm('Do you want to delete user ' + user.get('username') + '?');
            if (ans) {
              user.destroyRecord().then(function() {
                return true;
              }, function(errors) {
                user.rollback();
                return alert(errors.responseText);
              });
            }
            return false;
          }
        }
      });
      App.UsersNewController = Ember.ObjectController.extend({
        user: {
          role: {}
        },
        roles: ['editor', 'instructor'],
        prepare: function(user) {
          return user;
        },
        actions: {
          add: function() {
            var result, user;
            this.set('user.errors', null);
            user = this.store.createRecord('user', this.get('user'));
            result = user.validate();
            if (!result) {
              this.set('user.errors', user.errors);
              return false;
            }
            user.save().then(function() {
              return $('.modal-admin-user').modal('hide');
            }, function(errors) {
              user.rollback();
              return alert(errors.responseText);
            });
            return false;
          }
        }
      });
      App.SchoolsView = Ember.View.extend({
        didInsertElement: function() {
          this._super();
          return $('.nav-sidebar a:first').click();
        }
      });
      App.SchoolsController = Ember.ArrayController.extend({
        school: {},
        itemController: 'school',
        actions: {
          add: function(school) {
            this.set('school.errors', null);
            this.set('isAdding', true);
            return false;
          },
          save: function(school) {
            var result, thiz;
            thiz = this;
            school = this.store.createRecord('school', school);
            result = school.validate();
            if (!result) {
              this.set('school.errors', school.errors);
              return false;
            }
            school.save().then(function() {
              thiz.set('school.name', null);
              return thiz.set('isAdding', false);
            }, function(errors) {
              school.rollback();
              return alert(errors.responseText);
            });
            return false;
          },
          cancel: function() {
            this.set('school.name', null);
            this.set('isAdding', false);
            return false;
          }
        }
      });
      App.SchoolController = Ember.ObjectController.extend({
        needs: 'schools',
        needs: 'schoolEdit',
        schoolEdit: Ember.computed.alias('controllers.schoolEdit'),
        actions: {
          select: function(school) {
            var id;
            id = school.get('id');
            $('.nav-sidebar li').removeClass('active');
            $('.nav-sidebar li[data-id="' + id + '"]').addClass('active');
            return this.get('schoolEdit').send('update', school);
          }
        }
      });
      return App.SchoolEditController = Ember.ObjectController.extend({
        selectedSubjectChanged: (function() {
          if ((this.get('selectedSubject.terms') != null) && this.get('selectedSubject.terms').length > 0) {
            return this.set('selectedTerm', this.get('selectedSubject.terms')[0]);
          } else {
            return this.set('selectedTerm', null);
          }
        }).observes('selectedSubject'),
        actions: {
          update: function(school) {
            this.set('model', school);
            this.set('selectedSubject', this.get('info.subjects')[0]);
            return this.set('selectedTerm', this.get('selectedSubject.terms')[0]);
          },
          addSubject: function() {
            this.set('isAddingSubject', true);
            return false;
          },
          cancelSubject: function() {
            this.set('subject', null);
            this.set('isAddingSubject', false);
            return false;
          },
          saveSubject: function(subject) {
            var info, school;
            info = this.get('info');
            info.subjects.pushObject({
              name: subject,
              code: subject,
              terms: []
            });
            this.set('info', info);
            this.set('subject', null);
            this.set('isAddingSubject', false);
            school = this.get('model');
            school.save().then(function() {
              return false;
            }, function(errors) {
              return alert(errors.responseText);
            });
            return false;
          }
        }
      });
    }
  };
  return AdminRoute;
});
