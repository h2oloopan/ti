// Generated by CoffeeScript 1.6.3
define(['jquery', 'me', '/js/MathJax/MathJax.js?config=TeX-AMS-MML_HTMLorMML', 'ehbs!templates/questions/questions.index', 'ehbs!templates/questions/questions.new'], function($, me) {
  var QuestionsRoute;
  QuestionsRoute = {
    setup: function(App) {
      me.attach(App, ['Question', 'School']);
      App.Router.map(function() {
        return this.resource('questions', function() {
          return this.route('new');
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
            return thiz.transitionTo('login');
          });
        }
      });
      App.QuestionsNewRoute = Ember.Route.extend({
        model: function() {
          return this.store.createRecord('question', {});
        }
      });
      App.QuestionsNewView = Ember.View.extend({
        didInsertElement: function() {
          var Preview;
          this._super();
          Preview = this.controller.get('Preview');
          Preview.init();
          Preview.callback = MathJax.Callback(['createPreview', Preview]);
          return Preview.callback.autoReset = true;
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
          updateMath: function() {
            return this.Preview.update();
          },
          add: function() {
            return console.log(this.get('model'));
          }
        }
      });
    }
  };
  return QuestionsRoute;
});
