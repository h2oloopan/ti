// Generated by CoffeeScript 1.7.1
define(['jquery', 'me', 'utils', 'js/MathJax/MathJax.js?config=TeX-AMS-MML_HTMLorMML', 'ehbs!templates/questions/question.edit', 'ehbs!templates/questions/questions.index', 'ehbs!templates/questions/questions.new'], function($, me, utils) {
  var QuestionsRoute;
  QuestionsRoute = {
    setup: function(App) {
      App.Router.map(function() {
        this.resource('questions', function() {
          return this.route('new');
        });
        return this.resource('question', {
          path: '/question/:question_id'
        }, function() {
          return this.route('edit');
        });
      });
      App.QuestionsRoute = Ember.Route.extend({
        beforeModel: function() {
          var thiz;
          thiz = this;
          return me.auth.check().then(function(user) {
            if (user == null) {
              return thiz.transitionTo('login');
            }
          }, function(errors) {
            this.fail;
            return thiz.transitionTo('login');
          });
        }
      });
      App.QuestionRoute = Ember.Route.extend({
        beforeModel: function() {
          var thiz;
          thiz = this;
          return me.auth.check().then(function(user) {
            if (user == null) {
              return thiz.transitionTo('login');
            }
          }, function(errors) {
            this.fail;
            return thiz.transitionTo('login');
          });
        }
      });
      App.QuestionEditRoute = Ember.Route.extend({
        model: function() {
          var qid, thiz;
          thiz = this;
          qid = this.modelFor('question').id;
          return new Ember.RSVP.Promise(function(resolve, reject) {
            return new Ember.RSVP.hash({
              question_real: thiz.store.find('question', qid),
              question_fake: thiz.store.createRecord('question', {}),
              schools: thiz.store.find('school')
            }).then(function(result) {
              return resolve({
                question_real: result.question_real,
                question_fake: result.question_fake,
                schools: result.schools
              });
            }, function(errors) {
              return reject(errors);
            });
          });
        },
        afterModel: function(model, transition) {
          var c, course, fake, real, s, school, subject, t, term, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
          real = model.question_real;
          fake = model.question_fake;
          fake.set('school', real.get('school'));
          school = fake.get('school').toJSON();
          real.eachAttribute(function(name, meta) {
            return fake.set(name, real.get(name));
          });
          fake.set('id', real.get('id'));
          fake.set('initialize', {
            subject: true,
            term: true,
            course: true
          });
          term = school.info.terms[0];
          _ref = school.info.terms;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            t = _ref[_i];
            if (t.name === real.get('term')) {
              term = t;
              break;
            }
          }
          fake.set('term', term);
          subject = term.subjects[0];
          _ref1 = term.subjects;
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            s = _ref1[_j];
            if (s.name === real.get('subject')) {
              subject = s;
              break;
            }
          }
          fake.set('subject', subject);
          course = subject.courses[0];
          _ref2 = subject.courses;
          for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
            c = _ref2[_k];
            if (c.number === real.get('course')) {
              course = c;
              break;
            }
          }
          return fake.set('course', course);
        }
      });
      App.QuestionEditView = Ember.View.extend({
        didInsertElement: function() {
          var hintEditor, questionEditor, solutionEditor, summaryEditor;
          this._super();
          questionEditor = utils.createMathEditor($('#question-input'), $('#question-preview'));
          hintEditor = utils.createMathEditor($('#hint-input'), $('#hint-preview'));
          solutionEditor = utils.createMathEditor($('#solution-input'), $('#solution-preview'));
          summaryEditor = utils.createMathEditor($('#summary-input'), $('#summary-preview'));
          questionEditor.update();
          hintEditor.update();
          solutionEditor.update();
          return summaryEditor.update();
        }
      });
      App.QuestionEditController = Ember.ObjectController.extend({
        types: ['other', 'assignment', 'midterm', 'final', 'textbook'],
        difficulties: [1, 2, 3, 4, 5],
        terms: (function() {
          var school;
          school = this.get('question_fake.school');
          if (school == null) {
            return [];
          }
          if (this.get('question_fake.initialize.term')) {
            this.set('question_fake.initialize.term', false);
          } else {
            this.set('question_fake.term', school.toJSON().info.terms[0]);
          }
          return school.toJSON().info.terms;
        }).property('question_fake.school'),
        subjects: (function() {
          var term;
          term = this.get('question_fake.term');
          if (term == null) {
            return [];
          }
          if (this.get('question_fake.initialize.subject')) {
            this.set('question_fake.initialize.subject', false);
          } else {
            this.set('question_fake.subject', term.subjects[0]);
          }
          return term.subjects;
        }).property('question_fake.term'),
        courses: (function() {
          var subject;
          subject = this.get('question_fake.subject');
          if (subject == null) {
            return [];
          }
          if (this.get('question_fake.initialize.course')) {
            this.set('question_fake.initialize.course', false);
          } else {
            this.set('question_fake.course', subject.courses[0]);
          }
          return subject.courses;
        }).property('question_fake.subject'),
        prepare: function(question) {
          var another;
          another = question.toJSON();
          another.subject = question.get('subject.name');
          another.term = question.get('term.name');
          another.course = question.get('course.number');
          another.question = $('#question-input').html();
          another.hint = $('#hint-input').html();
          another.solution = $('#solution-input').html();
          another.summary = $('#summary-input').html();
          if (question.get('difficulty') == null) {
            another.difficulty = 0;
          }
          another = this.store.createRecord('Question', another);
          return another.set('school', question.get('school'));
        },
        actions: {
          save: function() {
            var key, keys, question, question_fake, result, thiz, _i, _len;
            thiz = this;
            question_fake = this.prepare(this.get('question_fake'));
            result = question_fake.validate();
            this.set('question_fake.errors', question_fake.errors);
            keys = me.keys(question_fake.errors);
            for (_i = 0, _len = keys.length; _i < _len; _i++) {
              key = keys[_i];
              alert(question_fake.errors[key]);
            }
            if (!result) {
              return false;
            }
            question = this.get('question_real');
            question.eachAttribute(function(name, meta) {
              return question.set(name, question_fake.get(name));
            });
            question.save().then(function() {
              return thiz.transitionToRoute('questions');
            }, function(errors) {
              question.rollback;
              console.log(errors);
              return alert(errors);
            });
            return false;
          }
        }
      });
      App.QuestionsIndexRoute = Ember.Route.extend({
        model: function() {
          return this.store.find('question');
        }
      });
      App.QuestionsIndexController = Ember.ArrayController.extend({
        sortProperties: ['id'],
        sortAscending: false,
        preview: {},
        itemController: 'questionItem'
      });
      App.QuestionItemController = Ember.ObjectController.extend({
        isHidden: (function() {
          if (this.get('flag') > 0) {
            return false;
          }
          return true;
        }).property('flag'),
        needs: 'questionsIndex',
        actions: {
          "delete": function(question) {
            var ans, name;
            name = question.get('school.name') + ' ' + question.get('term') + ' ' + question.get('subject') + ' ' + question.get('course');
            ans = confirm('Do you want to delete question ' + question.get('id') + ' of ' + name + '?');
            if (ans) {
              question.set('flag', 0);
              question.save().then(function() {
                return true;
              }, function(errors) {
                question.rollback();
                return alert(errors.responseText);
              });
            }
            return false;
          },
          view: function(question) {
            var hintView, questionView, solutionView, summaryView;
            this.set('controllers.questionsIndex.preview', question);
            question = question.toJSON();
            questionView = $('#question-view').html(question.question);
            hintView = $('#hint-view').html(question.hint);
            solutionView = $('#solution-view').html(question.solution);
            summaryView = $('#summary-view').html(question.summary);
            MathJax.Hub.Queue(['Typeset', MathJax.Hub, $('#modal-math')[0]]);
            $('.modal').modal();
            return false;
          }
        }
      });
      App.QuestionsNewRoute = Ember.Route.extend({
        model: function() {
          var thiz;
          thiz = this;
          return new Ember.RSVP.Promise(function(resolve, reject) {
            return new Ember.RSVP.hash({
              question: thiz.store.createRecord('question', {}),
              schools: thiz.store.find('school')
            }).then(function(result) {
              return resolve({
                question: result.question,
                schools: result.schools
              });
            }, function(errors) {
              return reject(errors);
            });
          });
        },
        afterModel: function(model, transition) {
          return this.controllerFor('questionsNew').set('initialize', {
            school: true
          });
        }
      });
      App.QuestionsNewView = Ember.View.extend({
        didInsertElement: function() {
          var hintEditor, questionEditor, solutionEditor, summaryEditor;
          this._super();
          questionEditor = utils.createMathEditor($('#question-input'), $('#question-preview'));
          hintEditor = utils.createMathEditor($('#hint-input'), $('#hint-preview'));
          solutionEditor = utils.createMathEditor($('#solution-input'), $('#solution-preview'));
          return summaryEditor = utils.createMathEditor($('#summary-input'), $('#summary-preview'));
        }
      });
      return App.QuestionsNewController = Ember.ObjectController.extend({
        initialize: null,
        needs: 'application',
        types: ['other', 'assignment', 'midterm', 'final', 'textbook'],
        difficulties: [1, 2, 3, 4, 5],
        settings: (function() {
          var cookie, data;
          cookie = $.cookie('settings');
          if (cookie == null) {
            return null;
          }
          data = JSON.parse(cookie);
          if ((data != null) && data.uid === this.get('controllers.application.model._id')) {
            return data;
          } else {
            return null;
          }
        }).property('initialize'),
        terms: (function() {
          var found, school, settings;
          school = this.get('question.school');
          if (school == null) {
            this.set('question.term', null);
            return [];
          }
          if (school.toJSON().info.terms.length > 0) {
            if (this.get('initialize.term')) {
              settings = this.get('settings');
              found = school.toJSON().info.terms.find(function(item) {
                if (item.name === settings.term) {
                  return true;
                }
                return false;
              });
              if (found != null) {
                this.set('question.term', found);
                this.set('initialize.subject', true);
              }
              this.set('initialize.term', false);
            } else {
              this.set('question.term', school.toJSON().info.terms[0]);
            }
          } else {
            this.set('question.term', null);
          }
          return school.toJSON().info.terms;
        }).property('question.school'),
        subjects: (function() {
          var found, settings, term;
          term = this.get('question.term');
          if (term == null) {
            this.set('question.subject', null);
            return [];
          }
          if ((term.subjects != null) && term.subjects.length > 0) {
            if (this.get('initialize.subject')) {
              settings = this.get('settings');
              found = term.subjects.find(function(item) {
                if (item.name === settings.subject) {
                  return true;
                }
                return false;
              });
              if (found != null) {
                this.set('question.subject', found);
                this.set('initialize.course', true);
              }
              this.set('initialize.subject', false);
            } else {
              this.set('question.subject', term.subjects[0]);
            }
          } else {
            this.set('question.subject', null);
          }
          return term.subjects;
        }).property('question.term'),
        courses: (function() {
          var found, settings, subject;
          subject = this.get('question.subject');
          if (subject == null) {
            this.set('question.course', null);
            return [];
          }
          if ((subject.courses != null) && subject.courses.length > 0) {
            if (this.get('initialize.course')) {
              settings = this.get('settings');
              found = subject.courses.find(function(item) {
                if (item.number === settings.course) {
                  return true;
                }
                return false;
              });
              if (found != null) {
                this.set('question.course', found);
                found = this.get('types').find(function(item) {
                  if (item === settings.type) {
                    return true;
                  }
                  return false;
                });
                if (found != null) {
                  this.set('question.type', found);
                }
              }
              this.set('initialize.course', false);
            } else {
              this.set('question.course', subject.courses[0]);
            }
          } else {
            this.set('question.course', null);
          }
          return subject.courses;
        }).property('question.subject'),
        schoolsChanged: (function() {
          var found, settings;
          if (this.get('initialize.school')) {
            settings = this.get('settings');
            found = this.get('schools').find(function(item) {
              if (item.get('name') === settings.school) {
                return true;
              }
              return false;
            });
            if (found != null) {
              this.set('question.school', found);
              this.set('initialize.term', true);
            }
            return this.set('initialize.school', false);
          }
        }).observes('schools'),
        prepare: function(question) {
          var another;
          another = question.toJSON();
          another.term = question.get('term.name');
          another.subject = question.get('subject.name');
          another.course = question.get('course.number');
          another.question = $('#question-input').html();
          another.hint = $('#hint-input').html();
          another.solution = $('#solution-input').html();
          another.summary = $('#summary-input').html();
          if (question.get('difficulty') == null) {
            another.difficulty = 0;
          }
          another = this.store.createRecord('Question', another);
          another.set('school', question.get('school'));
          return another;
        },
        saveSettings: function() {
          var settings;
          settings = {
            uid: this.get('controllers.application.model._id'),
            school: this.get('question.school.name'),
            term: this.get('question.term.name'),
            subject: this.get('question.subject.name'),
            course: this.get('question.course.number'),
            type: this.get('question.type')
          };
          return $.cookie('settings', JSON.stringify(settings), {
            expires: 7
          });
        },
        actions: {
          add: function() {
            var key, keys, question, result, thiz, _i, _len;
            thiz = this;
            question = this.prepare(this.get('question'));
            result = question.validate();
            this.set('question.errors', question.errors);
            keys = me.keys(question.errors);
            for (_i = 0, _len = keys.length; _i < _len; _i++) {
              key = keys[_i];
              alert(question.errors[key]);
            }
            if (!result) {
              return false;
            }
            question.save().then(function() {
              thiz.saveSettings();
              return thiz.transitionToRoute('questions');
            }, function(errors) {
              question.rollback();
              console.log(errors);
              return alert(errors);
            });
            return false;
          }
        }
      });
    }
  };
  return QuestionsRoute;
});
