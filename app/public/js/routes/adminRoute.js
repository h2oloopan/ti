// Generated by CoffeeScript 1.7.1
define(['jquery', 'me', 'utils', 'ehbs!templates/admin/admin', 'ehbs!templates/admin/users', 'ehbs!templates/admin/users.new', 'ehbs!templates/admin/users.edit', 'ehbs!templates/admin/schools', 'ehbs!templates/admin/school.edit'], function($, me, utils) {
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
        needs: 'usersEdit',
        isAdmin: (function() {
          if (this.get('model.power') >= 999) {
            return true;
          } else {
            return false;
          }
        }).property('power'),
        type: (function() {}).property('power'),
        actions: {
          edit: function(user) {
            var thiz;
            thiz = this;
            user.set('password', null);
            this.store.find('school').then(function(schools) {
              thiz.set('controllers.usersEdit.model', {
                user: user,
                schools: schools
              });
              $('.modal-admin-user-edit').modal();
              return true;
            }, function(errors) {
              return false;
            });
            return false;
          },
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
      App.UsersEditController = Ember.ObjectController.extend({
        roles: ['editor', 'instructor'],
        errors: {},
        isAddingPrivilege: false,
        cleanPrivilege: function() {
          this.set('term', null);
          this.set('subject', null);
          return this.set('course', null);
        },
        actions: {
          addPrivilege: function() {
            this.set('isAddingPrivilege', true);
            return false;
          },
          savePrivilege: function() {
            var privileges, user;
            if ((this.get('school') == null) && me.isEmptyString(this.get('term')) && me.isEmptyString(this.get('subject')) && me.isEmptyString(this.get('course'))) {
              alert('Cannot enter an empty row of privilege');
              return false;
            }
            if (me.isEmptyString(this.get('subject')) && !me.isEmptyString(this.get('course'))) {
              alert('Course must be coupled with subject');
              return false;
            }
            user = this.get('user');
            privileges = user.get('privileges');
            privileges.pushObject({
              school: this.get('school'),
              term: this.get('term'),
              subject: this.get('subject'),
              course: this.get('course')
            });
            user.set('privileges', privileges);
            this.cleanPrivilege();
            this.set('isAddingPrivilege', false);
            return false;
          },
          cancelPrivilege: function() {
            this.cleanPrivilege();
            this.set('isAddingPrivilege', false);
            return false;
          },
          deletePrivilege: function(privilege) {
            var privileges;
            privileges = this.get('user.privileges');
            privileges.removeObject(privilege);
            this.set('user.privileges', privileges);
            return false;
          },
          save: function(user) {
            var key, keys, result, _i, _len;
            result = user.validate();
            keys = me.keys(user.errors);
            for (_i = 0, _len = keys.length; _i < _len; _i++) {
              key = keys[_i];
              if (key !== 'password') {
                this.set('errors.' + key, errors[key]);
                return false;
              }
            }
            user.save().then(function() {
              return $('.modal-admin-user-edit').modal('hide');
            }, function(errors) {
              user.rollback();
              return alert(errors.responseText);
            });
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
        selectedTermChange: (function() {
          if (this.get('isReset')) {
            this.set('isReset', false);
            return false;
          }
          if ((this.get('selectedTerm.subjects') != null) && this.get('selectedTerm.subjects').length > 0) {
            return this.set('selectedSubject', this.get('selectedTerm.subjects')[0]);
          } else {
            return this.set('selectedSubject', null);
          }
        }).observes('selectedTerm'),
        actions: {
          update: function(school) {
            this.set('model', school);
            this.set('isEditing', true);
            if (this.get('info.terms').length > 0) {
              this.set('selectedTerm', this.get('info.terms')[0]);
              if (this.get('selectedTerm.subjects').length > 0) {
                return this.set('selectedSubject', this.get('selectedTerm.subjects')[0]);
              }
            }
          },
          deleteSchool: function(school) {
            alert('We are not allowed to delete school at the moment');
            return false;
          },
          addCourse: function() {
            this.set('isAddingCourse', true);
            return false;
          },
          cancelCourse: function() {
            this.set('course', null);
            this.set('isAddingCourse', false);
            return false;
          },
          saveCourse: function(course) {
            var match, school, selectedSubject, selectedTerm, thiz;
            thiz = this;
            selectedTerm = this.get('selectedTerm');
            selectedSubject = this.get('selectedSubject');
            match = function(item) {
              if (item.number.toLowerCase() === course.toLowerCase()) {
                return true;
              } else {
                return false;
              }
            };
            if (selectedSubject.courses.any(match)) {
              alert('You cannot add course with same name/number');
              return false;
            }
            selectedSubject.courses.pushObject({
              number: course,
              name: ''
            });
            this.set('course', null);
            this.set('isAddingCourse', false);
            school = this.get('model');
            school.save().then(function() {
              var found;
              found = school.get('info.terms').find(function(item) {
                if (item.name === selectedTerm.name) {
                  return true;
                }
                return false;
              });
              if (found == null) {
                return false;
              }
              thiz.set('isReset', true);
              thiz.set('selectedTerm', found);
              found = found.subjects.find(function(item) {
                if (item.name === selectedSubject.name) {
                  return true;
                }
                return false;
              });
              if (found == null) {
                return false;
              }
              thiz.set('selectedSubject', found);
              return true;
            }, function(errors) {
              school.rollback();
              return alert(errors.responseText);
            });
            return false;
          },
          deleteCourse: function(course) {
            var ans, school, selectedSubject, selectedTerm, thiz;
            thiz = this;
            ans = confirm('Are you sure you want to delete course ' + course.number + '?');
            if (!ans) {
              return false;
            }
            selectedTerm = this.get('selectedTerm');
            selectedSubject = this.get('selectedSubject');
            selectedSubject.courses.removeObject(course);
            school = this.get('model');
            school.save().then(function() {
              var found;
              found = school.get('info.terms').find(function(item) {
                if (item.name === selectedTerm.name) {
                  return true;
                }
                return false;
              });
              if (found == null) {
                return false;
              }
              found = found.subjects.find(function(item) {
                if (item.name === selectedSubject.name) {
                  return true;
                }
                return false;
              });
              if (found == null) {
                return false;
              }
              thiz.set('selectedSubject', found);
              return true;
            }, function(errors) {
              school.rollback();
              return alert(errors.responseText);
            });
            return false;
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
            var match, school, selectedTerm, thiz;
            thiz = this;
            selectedTerm = this.get('selectedTerm');
            match = function(item) {
              if (item.name.toLowerCase() === subject.toLowerCase()) {
                return true;
              } else {
                return false;
              }
            };
            if (selectedTerm.subjects.any(match)) {
              alert('You cannot add subject with same name');
              return false;
            }
            selectedTerm.subjects.pushObject({
              name: subject,
              courses: []
            });
            this.set('subject', null);
            this.set('isAddingSubject', false);
            school = this.get('model');
            school.save().then(function() {
              var found;
              found = school.get('info.terms').find(function(item) {
                if (item.name === selectedTerm.name) {
                  return true;
                }
                return false;
              });
              if (found == null) {
                return false;
              }
              thiz.set('isReset', true);
              thiz.set('selectedTerm', found);
              thiz.set('selectedSubject', found.subjects[found.subjects.length - 1]);
              return true;
            }, function(errors) {
              school.rollback();
              return alert(errors.responseText);
            });
            return false;
          },
          deleteSubject: function(subject) {
            var ans, school, selectedTerm;
            ans = confirm('Are you sure you want to delete subject ' + subject.name + '?');
            if (!ans) {
              return false;
            }
            selectedTerm = this.get('selectedTerm');
            selectedTerm.subjects.removeObject(subject);
            school = this.get('model');
            school.save().then(function() {
              var found;
              found = school.get('info.terms').find(function(item) {
                if (item.name === selectedTerm.name) {
                  return true;
                }
                return false;
              });
              if (found == null) {
                return false;
              }
              thiz.set('selectedTerm', found);
              return true;
            }, function(errors) {
              school.rollback();
              return alert(errors.responseText);
            });
            return false;
          },
          addTerm: function() {
            this.set('isAddingTerm', true);
            return false;
          },
          cancelTerm: function() {
            this.set('term', null);
            this.set('isAddingTerm', false);
            return false;
          },
          saveTerm: function(term) {
            var info, match, school, thiz;
            thiz = this;
            info = this.get('info');
            match = function(item) {
              if (item.name.toLowerCase() === term.toLowerCase()) {
                return true;
              } else {
                return false;
              }
            };
            if (info.terms.any(match)) {
              alert('You cannot add term with same name');
              return false;
            }
            info.terms.pushObject({
              name: term,
              subjects: []
            });
            this.set('term', null);
            this.set('isAddingTerm', false);
            school = this.get('model');
            school.save().then(function() {
              thiz.set('selectedTerm', thiz.get('info.terms')[thiz.get('info.terms').length - 1]);
              return true;
            }, function(errors) {
              school.rollback();
              return alert(errors.responseText);
            });
            return false;
          },
          deleteTerm: function(term) {
            var ans, info, school, thiz;
            thiz = this;
            ans = confirm('Are you sure you want to delete term ' + term.name + '?');
            if (!ans) {
              return false;
            }
            info = this.get('info');
            info.terms.removeObject(term);
            this.set('selectedTerm', null);
            school = this.get('model');
            school.save().then(function() {
              return true;
            }, function(errors) {
              school.rollback();
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
