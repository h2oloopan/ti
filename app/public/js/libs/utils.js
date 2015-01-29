// Generated by CoffeeScript 1.8.0
define(['jquery', 'bootstrap-wysiwyg'], function($) {
  var utils;
  return utils = {
    createMathEditor: function(input, preview, options) {
      var MathEditor;
      MathEditor = (function() {
        function MathEditor(input, preview, options) {
          this.input = input;
          this.preview = preview;
          this.options = options;
          this.init();
        }

        MathEditor.prototype.delay = 300;

        MathEditor.prototype.timeout = null;

        MathEditor.prototype.running = false;

        MathEditor.prototype.checking = false;

        MathEditor.prototype.init = function() {
          var check, counter, interval, minimum, poll, recurrence, thiz, timer, url;
          thiz = this;
          $(this.input).wysiwyg();
          $(this.input).on('keypress', function() {
            return thiz.update();
          });
          $(this.input).on('paste', function(e) {
            var content;
            e.preventDefault();
            if (e.originalEvent.clipboardData) {
              content = (e.originalEvent || e).clipboardData.getData('text/plain');
              return document.execCommand('insertText', false, content);
            } else if (window.clipboardData) {
              content = window.clipboardData.getData('Text');
              return document.selection.createRange().pasteHTML(content);
            }
          });
          this.options = this.options || {};
          check = this.options.check || false;
          url = this.options.url || null;
          if (check && (url != null)) {
            interval = this.options.interval || 5000;
            minimum = this.options.minimum || 50;
            recurrence = this.options.recurrence || 3;
            timer = null;
            counter = 0;
            poll = function(counter) {
              if (checking) {
                return;
              }
              if (counter > recurrence) {
                return clearInterval(timer);
              }
              return counter++;
            };
            return timer = setInterval(function() {
              return poll();
            }, interval);
          }
        };

        MathEditor.prototype.update = function() {
          var thiz;
          thiz = this;
          if (this.timeout) {
            clearTimeout(this.timeout);
          }
          return this.timeout = setTimeout(function() {
            var content;
            if (thiz.running) {
              return;
            }
            content = $(thiz.input).html();
            $(thiz.preview).html(content);
            thiz.running = true;
            return MathJax.Hub.Queue(['Typeset', MathJax.Hub, $(thiz.preview)[0]], ['done', thiz]);
          }, this.delay);
        };

        MathEditor.prototype.done = function() {
          return this.running = false;
        };

        return MathEditor;

      })();
      return new MathEditor(input, preview, options);
    }
  };
});
