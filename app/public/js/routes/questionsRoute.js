// Generated by CoffeeScript 1.9.1
define(['jquery', 'me', 'utils', 'components/photo-upload', 'moment', 'js/MathJax/MathJax.js?config=TeX-AMS-MML_HTMLorMML', 'bootstrap-tagsinput', 'ehbs!templates/questions/question.index', 'ehbs!templates/questions/question.edit', 'ehbs!templates/questions/questions.index', 'ehbs!templates/questions/questions.select', 'ehbs!templates/questions/questions.new'], function($, me, utils, PhotoUploadComponent, mmt) {
  var QuestionsRoute;
  QuestionsRoute = {
    setup: function(App) {
      Ember.Handlebars.registerBoundHelper('display-time', function(format, time) {
        return moment(time).format(format);
      });
      App.Router.map(function() {
        this.resource('questions', function() {
          this.route('new');
          return this.route('select');
        });
        return this.resource('question', {
          path: '/question/:question_id'
        }, function() {
          return this.route('edit');
        });
      });
      App.PhotoUploadComponent = PhotoUploadComponent;
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
          var c, course, fake, i, j, len, len1, real, ref, ref1, s, school, subject;
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
            course: true
          });
          subject = school.info.subjects[0];
          ref = school.info.subjects;
          for (i = 0, len = ref.length; i < len; i++) {
            s = ref[i];
            if (s.name === real.get('subject')) {
              subject = s;
              break;
            }
          }
          fake.set('subject', subject);
          course = subject.courses[0];
          ref1 = subject.courses;
          for (j = 0, len1 = ref1.length; j < len1; j++) {
            c = ref1[j];
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
          $('#type-tags').tagsinput();
          $('#tags').tagsinput();
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
        uploadLink: '/api/images/temp',
        difficulties: [1, 2, 3, 4, 5],
        terms: (function() {
          var school;
          school = this.get('question_fake.school');
          if (school == null) {
            return [];
          }
          if (school.toJSON().terms.length > 0) {
            this.set('selectedTerm', school.toJSON().terms[0]);
          }
          return school.toJSON().terms;
        }).property('question_fake.school'),
        types: (function() {
          var school;
          school = this.get('question_fake.school');
          if (school == null) {
            return [];
          }
          if (school.toJSON().types.length > 0) {
            this.set('selectedType', school.toJSON().types[0]);
          }
          return school.toJSON().types;
        }).property('question_fake.school'),
        subjects: (function() {
          var school;
          school = this.get('question_fake.school');
          if (school == null) {
            return [];
          }
          if (this.get('question_fake.initialize.subject')) {
            this.set('question_fake.initialize.subject', false);
          } else {
            this.set('question_fake.subject', school.info.subjects[0]);
          }
          return school.toJSON().info.subjects;
        }).property('question_fake.school'),
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
          another.course = question.get('course.number');
          another.question = $('#question-input').cleanHtml();
          another.hint = $('#hint-input').cleanHtml();
          another.solution = $('#solution-input').cleanHtml();
          another.summary = $('#summary-input').cleanHtml();
          another.typeTags = $('#type-tags').val().replace(/, /g, ',').replace(/,/g, ', ');
          another.tags = $('#tags').val().replace(/, /g, ',').replace(/,/g, ', ');
          if (question.get('difficulty') == null) {
            another.difficulty = 0;
          }
          another = this.store.createRecord('Question', another);
          return another.set('school', question.get('school'));
        },
        actions: {
          addTypeTag: function() {
            var tag, term, type;
            term = this.get('selectedTerm');
            type = this.get('selectedType');
            tag = term + ' ' + type;
            $('#type-tags').tagsinput('add', tag);
            return false;
          },
          save: function() {
            var i, key, keys, len, question, question_fake, result, thiz;
            thiz = this;
            question_fake = this.prepare(this.get('question_fake'));
            result = question_fake.validate();
            this.set('question_fake.errors', question_fake.errors);
            keys = me.keys(question_fake.errors);
            for (i = 0, len = keys.length; i < len; i++) {
              key = keys[i];
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
              return alert(errors.responseText);
            });
            return false;
          }
        }
      });
      App.QuestionIndexRoute = Ember.Route.extend({
        model: function() {
          var qid;
          qid = this.modelFor('question').id;
          return this.store.find('question', qid);
        }
      });
      App.QuestionIndexView = Ember.View.extend({
        didInsertElement: function() {
          var question;
          this._super();
          question = this.controller.get('model').toJSON();
          $('#question-preview').html(question.question);
          $('#hint-preview').html(question.hint);
          $('#solution-preview').html(question.solution);
          $('#summary-preview').html(question.summary);
          return MathJax.Hub.Queue(['Typeset', MathJax.Hub, $('.question-form .right')[0]]);
        }
      });
      App.QuestionIndexController = Ember.ObjectController.extend({
        actions: {
          back: function() {
            window.history.go(-1);
            return false;
          }
        }
      });
      App.QuestionsIndexRoute = Ember.Route.extend({
        model: function() {
          return this.store.find('question', {
            advanced: JSON.stringify({
              skip: 0,
              limit: 50
            })
          });
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
          }
        }
      });
      App.QuestionsSelectRoute = Ember.Route.extend({
        model: function() {
          var thiz;
          thiz = this;
          return new Ember.RSVP.Promise(function(resolve, reject) {
            return new Ember.RSVP.hash({
              schools: thiz.store.find('school')
            }).then(function(result) {
              return resolve({
                schools: result.schools,
                questions: []
              });
            }, function(errors) {
              return reject(errors);
            });
          });
        }
      });
      App.QuestionsSelectView = Ember.View.extend({
        didInsertElement: function() {
          this._super();
          return $('#type-tags').tagsinput();
        }
      });
      App.QuestionsSelectController = Ember.ObjectController.extend({
        sortProperties: ['id'],
        sortAscending: false,
        advanced: {
          skip: 0,
          limit: 10
        },
        paging: {
          pages: {
            one: 1,
            two: 2,
            three: 3
          }
        },
        subjects: (function() {
          var school, subjects;
          school = this.get('school');
          if (school == null) {
            return [];
          }
          subjects = school.get('info.subjects');
          if (subjects.length > 0) {
            this.set('subject', subjects[0]);
          }
          return subjects;
        }).property('school'),
        courses: (function() {
          var courses, subject;
          subject = this.get('subject');
          if (subject == null) {
            return [];
          }
          courses = subject.courses;
          if (courses.length > 0) {
            this.set('course', courses[0]);
          }
          return courses;
        }).property('subject'),
        terms: (function() {
          var school, terms;
          school = this.get('school');
          if (school == null) {
            return [];
          }
          terms = school.get('terms');
          if (terms.length > 0) {
            this.set('term', terms[0]);
          }
          return terms;
        }).property('school'),
        types: (function() {
          var school, types;
          school = this.get('school');
          if (school == null) {
            return [];
          }
          types = school.get('types');
          if (types.length > 0) {
            this.set('type', types[0]);
          }
          return types;
        }).property('school'),
        actions: {
          update: function(advanced) {
            this.set('advanced', advanced);
            return this.set('questions', this.store.find('question', {
              advanced: JSON.stringify(advanced)
            }));
          },
          previous: function() {
            var advanced;
            advanced = this.get('advanced');
            if (advanced.skip === 0) {
              return false;
            } else if (advanced.skip < advanced.limit) {
              advanced.skip = 0;
            } else {
              advanced.skip -= advanced.limit;
            }
            this.send('update', advanced);
            return false;
          },
          next: function() {
            var advanced;
            advanced = this.get('advanced');
            advanced.skip += advanced.limit;
            this.send('update', advanced);
            return false;
          },
          jump: function(index) {
            return false;
          },
          addTypeTag: function() {
            var tag, term, type;
            term = this.get('term');
            type = this.get('type');
            tag = term + ' ' + type;
            $('#type-tags').tagsinput('add', tag);
            return false;
          },
          search: function() {
            var advanced;
            advanced = {
              skip: 0,
              limit: 10,
              school: this.get('school.id'),
              subject: this.get('subject.name'),
              course: this.get('course.number'),
              types: $('#type-tags').tagsinput('items')
            };
            this.send('update', advanced);
            return false;
          }
        }
      });
      App.QuestionSelectItemView = Ember.View.extend({
        isHidden: (function() {
          if (this.get('flag') > 0) {
            return false;
          }
          return true;
        }).property('flag'),
        didInsertElement: function() {
          var element;
          this._super();
          element = this.get('element');
          return MathJax.Hub.Queue(['Typeset', MathJax.Hub, element]);
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
          $('#type-tags').tagsinput();
          $('#tags').tagsinput();
          questionEditor = utils.createMathEditor($('#question-input'), $('#question-preview'), {
            check: true,
            url: '/api/search/questions/text',
            display: $('#question-display')
          });
          hintEditor = utils.createMathEditor($('#hint-input'), $('#hint-preview'));
          solutionEditor = utils.createMathEditor($('#solution-input'), $('#solution-preview'));
          return summaryEditor = utils.createMathEditor($('#summary-input'), $('#summary-preview'));
        }
      });
      return App.QuestionsNewController = Ember.ObjectController.extend({
        initialize: null,
        needs: 'application',
        difficulties: [1, 2, 3, 4, 5],
        uploadLink: '/api/images/temp',
        settings: (function() {
          var cookie, data;
          cookie = $.cookie('settings');
          if (cookie == null) {
            return null;
          }
          data = JSON.parse(cookie);
          return data[this.get('controllers.application.model._id')];
        }).property('initialize'),
        terms: (function() {
          var school;
          school = this.get('question.school');
          if (school == null) {
            return [];
          }
          if (school.toJSON().terms.length > 0) {
            this.set('selectedTerm', school.toJSON().terms[0]);
          }
          return school.toJSON().terms;
        }).property('question.school'),
        types: (function() {
          var school;
          school = this.get('question.school');
          if (school == null) {
            return [];
          }
          if (school.toJSON().types.length > 0) {
            this.set('selectedType', school.toJSON().types[0]);
          }
          return school.toJSON().types;
        }).property('question.school'),
        subjects: (function() {
          var found, school, settings;
          school = this.get('question.school');
          if (school == null) {
            this.set('question.subject', null);
            return [];
          }
          if (school.toJSON().info.subjects.length > 0) {
            if (this.get('initialize.subject') && this.get('settings')) {
              settings = this.get('settings');
              found = school.toJSON().info.subjects.find(function(item) {
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
              this.set('question.subject', school.toJSON().info.subjects[0]);
            }
          } else {
            this.set('question.subject', null);
          }
          return school.toJSON().info.subjects;
        }).property('question.school'),
        courses: (function() {
          var found, settings, subject;
          subject = this.get('question.subject');
          if (subject == null) {
            this.set('question.course', null);
            return [];
          }
          if ((subject.courses != null) && subject.courses.length > 0) {
            if (this.get('initialize.course') && this.get('settings')) {
              settings = this.get('settings');
              found = subject.courses.find(function(item) {
                if (item.number === settings.course) {
                  return true;
                }
                return false;
              });
              if (found != null) {
                this.set('question.course', found);
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
          if (this.get('initialize.school') && this.get('settings')) {
            settings = this.get('settings');
            found = this.get('schools').find(function(item) {
              if (item.get('name') === settings.school) {
                return true;
              }
              return false;
            });
            if (found != null) {
              this.set('question.school', found);
              this.set('initialize.subject', true);
            }
            return this.set('initialize.school', false);
          }
        }).observes('schools'),
        prepare: function(question) {
          var another;
          another = question.toJSON();
          another.subject = question.get('subject.name');
          another.course = question.get('course.number');
          another.question = $('#question-input').cleanHtml();
          another.hint = $('#hint-input').cleanHtml();
          another.solution = $('#solution-input').cleanHtml();
          another.summary = $('#summary-input').cleanHtml();
          another.typeTags = $('#type-tags').val().replace(',', ', ');
          another.tags = $('#tags').val().replace(',', ', ');
          if (question.get('difficulty') == null) {
            another.difficulty = 0;
          }
          another = this.store.createRecord('Question', another);
          another.set('school', question.get('school'));
          return another;
        },
        saveSettings: function() {
          var settings, storage, uid;
          uid = this.get('controllers.application.model._id');
          settings = {
            school: this.get('question.school.name'),
            subject: this.get('question.subject.name'),
            course: this.get('question.course.number')
          };
          storage = $.cookie('settings');
          if (storage == null) {
            storage = {};
          } else {
            storage = JSON.parse(storage);
          }
          storage[uid] = settings;
          return $.cookie('settings', JSON.stringify(storage), {
            expires: 7
          });
        },
        actions: {
          addTypeTag: function() {
            var tag, term, type;
            term = this.get('selectedTerm');
            type = this.get('selectedType');
            tag = term + ' ' + type;
            $('#type-tags').tagsinput('add', tag);
            return false;
          },
          add: function() {
            var i, key, keys, len, question, result, thiz;
            thiz = this;
            question = this.prepare(this.get('question'));
            result = question.validate();
            this.set('question.errors', question.errors);
            keys = me.keys(question.errors);
            for (i = 0, len = keys.length; i < len; i++) {
              key = keys[i];
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
              return alert(errors.responseText);
            });
            return false;
          }
        }
      });
    }
  };
  return QuestionsRoute;
});
