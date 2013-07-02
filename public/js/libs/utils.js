// Generated by CoffeeScript 1.6.3
(function() {
  define(['jquery'], function($) {
    var utils;
    return utils = {
      serialize: function(element, trim) {
        var a, form, o;
        if (trim == null) {
          trim = false;
        }
        o = {};
        if ($(element).is('form')) {
          form = element;
        } else {
          form = $('<form></form>').append($(element).clone());
        }
        a = form.serializeArray();
        $.each(a, function() {
          var value;
          if (o[this.name] !== void 0) {
            if (!o[this.name].push) {
              o[this.name] = [o[this.name]];
            }
            value = this.value || '';
            if (trim) {
              value = $.trim(value);
            }
            return o[this.name].push(value);
          } else {
            value = this.value || '';
            if (trim) {
              value = $.trim(value);
            }
            return o[this.name] = value;
          }
        });
        return o;
      },
      auth: function(cb) {
        return $.get('/api/account/auth').done(function() {
          return cb(true);
        }).fail(function() {
          return cb(false);
        });
      },
      logout: function(cb) {
        return $.post('/api/account/logout').always(function() {
          window.location.reload();
          return cb(null);
        });
      },
      login: function(user, cb) {
        return $.post('/api/account/login', user).done(function() {
          window.location.href = '/';
          return cb(null);
        }).fail(function(result) {
          return cb(result.responseText);
        });
      }
    };
  });

}).call(this);
