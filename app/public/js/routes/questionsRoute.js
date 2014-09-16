// Generated by CoffeeScript 1.6.3
define(['jquery', 'me', '/js/MathJax/MathJax.js?config=TeX-AMS-MML_HTMLorMML&delayStartupUntil=configured', 'ehbs!templates/questions/question.edit', 'ehbs!templates/questions/questions.index', 'ehbs!templates/questions/questions.new'], function($, me) {
  var QuestionsRoute;
  QuestionsRoute = {
    setup: function(App) {
      me.attach(App, ['Question', 'School']);
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
      App.QuestionsIndexRoute = Ember.Route.extend({
        beforeModel: function() {
          var thiz;
          thiz = this;
          return me.auth.check().then(function(user) {
            if (user == null) {
              return thiz.transitionTo('login');
            }
          }, function(errors) {
            return thiz.transitionTo('login');
          });
        },
        model: function() {
          return this.store.find('question');
        }
      });
      App.QuestionsIndexController = Ember.ArrayController.extend({
        itemController: 'question'
      });
      App.QuestionController = Ember.ObjectController.extend({
        needs: 'questionsIndex',
        actions: {
          "delete": function(question) {
            var ans;
            ans = confirm('Do you want to delete question ' + question.id + '?');
            if (ans) {
              question.destroyRecord().then(function() {
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
        }
      });
      App.QuestionsNewView = Ember.View.extend({
        didInsertElement: function() {
          var Preview;
          this._super();
          MathJax.Hub.Config({
            tex2jax: {
              inlineMath: [['$', '$'], ['\\(', '\\)']]
            }
          });
          MathJax.Hub.Configured();
          Preview = this.controller.get('Preview');
          Preview.init();
          Preview.callback = MathJax.Callback(['createPreview', Preview]);
          Preview.callback.autoReset = true;
          return $('#math-input').keyup(function() {
            return Preview.update();
          });
        }
      });
      return App.QuestionsNewController = Ember.ObjectController.extend({
        Preview: {
          delay: 150,
          preview: null,
          buffer: null,
          timeout: null,
          mjRunning: false,
          oldText: null,
          init: function() {
            this.preview = document.getElementById('math-preview');
            return this.buffer = document.getElementById('math-buffer');
          },
          swapBuffers: function() {
            var buffer, preview;
            buffer = this.preview;
            preview = this.buffer;
            buffer.style.visibility = 'hidden';
            buffer.style.position = 'absolute';
            preview.style.position = '';
            return preview.style.visibility = '';
          },
          update: function() {
            if (this.timeout) {
              clearTimeout(this.timeout);
            }
            return this.timeout = setTimeout(this.callback, this.delay);
          },
          createPreview: function() {
            var text;
            this.timeout = null;
            if (this.mjRunning) {
              return;
            }
            text = document.getElementById('math-input').value;
            if (text === this.oldtext) {
              return;
            }
            this.buffer.innerHTML = this.oldtext = text;
            this.mjRunning = true;
            return MathJax.Hub.Queue(['Typeset', MathJax.Hub, this.buffer], ['previewDone', this]);
          },
          previewDone: function() {
            this.mjRunning = false;
            return this.swapBuffers();
          }
        },
        actions: {
          add: function() {
            var question, result, thiz;
            thiz = this;
            question = this.get('question');
            result = question.validate();
            if (!result) {
              return false;
            }
            question.save().then(function() {
              return thiz.transitionToRoute('questions');
            }, function(errors) {
              return console.log(errors);
            });
            return false;
          }
        }
      });
    }
  };
  return QuestionsRoute;
});
