// Generated by CoffeeScript 1.7.1
define([], function() {
  var me;
  me = {
    keys: function(obj) {
      var func;
      if (!Object.keys) {
        func = function(obj) {
          var hasOwnProperty, prop, result;
          hasOwnProperty = Object.prototype.hasOwnProperty;
          if (typeof obj !== 'object' && (typeof obj !== 'function' || obj === null)) {
            throw new TypeError('Object.keys called on non-object');
            return;
          }
          result = [];
          for (prop in obj) {
            if (hasOwnProperty.call(obj, prop)) {
              result.push(prop);
            }
          }
          return result;
        };
        return func(obj);
      } else {
        return Object.keys(obj);
      }
    },
    restoreRegex: function(str) {
      var flags, lastSlash, pattern;
      lastSlash = str.lastIndexOf('/');
      pattern = str;
      if (lastSlash !== 0) {
        flags = str.substr(lastSlash + 1);
        pattern = str.substr(0, lastSlash + 1);
      }
      pattern = pattern.substr(1, pattern.length - 2);
      return new RegExp(pattern, flags);
    },
    version: 5715,
    models: {Question:{ model: {question: DS.attr("string"), hint: DS.attr("string"), solution: DS.attr("string"), summary: DS.attr("string"), note: DS.attr("string"), tags: DS.attr("string"), difficulty: DS.attr("number"), type: DS.attr("string"), flag: DS.attr("number"), school: DS.belongsTo("school"), term: DS.attr("string"), subject: DS.attr("string"), course: DS.attr("string"), editor: DS.belongsTo("user"), _id: DS.attr("string")}, adapter: {namespace: "api"}, serializer: {primaryKey: "_id"}, validations: {"question":[{"type":"required","message":"Question cannot be empty"}],"hint":[],"solution":[],"summary":[],"note":[],"tags":[],"difficulty":[],"type":[],"flag":[],"school":[{"type":"required","message":"School cannot be empty"}],"term":[{"type":"required","message":"Term cannot be empty"}],"subject":[{"type":"required","message":"Subject cannot be empty"}],"course":[{"type":"required","message":"Course cannot be empty"}],"editor":[],"_id":[]}},School:{ model: {name: DS.attr("string"), info: DS.attr("json"), _id: DS.attr("string")}, adapter: {namespace: "api"}, serializer: {primaryKey: "_id"}, validations: {"name":[{"type":"required","message":"School name cannot be empty"}],"info":[],"_id":[]}},User:{ model: {username: DS.attr("string"), password: DS.attr("string"), email: DS.attr("string"), power: DS.attr("number"), role: DS.attr("json"), _id: DS.attr("string")}, adapter: {namespace: "api"}, serializer: {primaryKey: "_id"}, validations: {"username":[{"type":"required","message":"Username cannot be empty"},{"type":"match","message":"Invalid username","parameters":["/^[A-Z0-9\\._-]+$/i"]}],"password":[{"type":"required","message":"Password cannot be empty"}],"email":[{"type":"required","message":"Email cannot be empty"},{"type":"match","message":"Invalid email address","parameters":["/^[A-Z0-9\\._%+-]+@[A-Z0-9\\.-]+\\.[A-Z]{2,4}$/i"]}],"power":[],"role":[],"_id":[]}}},
    validators: {
      required: function(value) {
        if (value === null || value === void 0 || value === '') {
          return false;
        } else {
          return true;
        }
      },
      match: function(value, parameters) {
        var regex;
        regex = me.restoreRegex(parameters[0]);
        return null !== value && ('' !== value ? regex.test(value) : true);
      }
    },
    attach: function(App, names) {
      var name, thiz, _i, _len;
      thiz = this;
      App.JsonTransform = DS.Transform.extend({
        serialize: function(value) {
          return value;
        },
        deserialize: function(value) {
          return value;
        }
      });
      for (_i = 0, _len = names.length; _i < _len; _i++) {
        name = names[_i];
        App[name] = DS.Model.extend(this.models[name].model);
        App[name].reopen({
          errors: {},
          modelName: name,
          validate: function(fields) {
            var flag, message, option, options, parameters, path, result, type, validations, validator, _j, _k, _len1, _len2, _ref;
            this.set('errors', {});
            flag = true;
            validations = me.models[this.modelName].validations;
            _ref = me.keys(validations);
            for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
              path = _ref[_j];
              if ((fields != null) && fields.indexOf(path) < 0) {
                continue;
              }
              options = validations[path];
              for (_k = 0, _len2 = options.length; _k < _len2; _k++) {
                option = options[_k];
                type = option.type;
                message = option.message;
                parameters = option.parameters;
                validator = thiz.validators[type];
                result = validator(this.get(path), parameters);
                if (!result) {
                  this.set('errors.' + path, message);
                }
                flag = flag && result;
              }
            }
            return flag;
          }
        });
        App[name + 'Adapter'] = DS.RESTAdapter.extend(this.models[name].adapter);
        App[name + 'Serializer'] = DS.RESTSerializer.extend(this.models[name].serializer);
      }
    },
    auth: {
      signup: function(user) {
        var data, url;
        url = '/api/auth/signup';
        data = JSON.stringify({
          user: user.toJSON()
        });
        return new Ember.RSVP.Promise(function(resolve, reject) {
          return $.ajax({
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            url: url,
            data: data,
            dataType: 'json'
          }).done(function(data) {
            return resolve(data);
          }).fail(function(data) {
            return reject(data.responseText);
          });
        });
      },
      login: function(user) {
        var data, json, url;
        url = '/api/auth/login';
        json = user.toJSON != null ? user.toJSON() : user;
        data = JSON.stringify({
          user: json
        });
        return new Ember.RSVP.Promise(function(resolve, reject) {
          return $.ajax({
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            url: url,
            data: data,
            dataType: 'json'
          }).done(function(data) {
            return resolve(data);
          }).fail(function(data) {
            return reject(data.responseText);
          });
        });
      },
      logout: function() {
        var url;
        url = '/api/auth/logout';
        return new Ember.RSVP.Promise(function(resolve, reject) {
          return $.get(url).done(function() {
            return resolve({});
          }).fail(function() {
            return resolve({});
          });
        });
      },
      power: function(point) {
        var url;
        url = '/api/auth/power' + '/' + point;
        return new Ember.RSVP.Promise(function(resolve, reject) {
          return $.get(url).done(function(data) {
            return resolve(data);
          }).fail(function(errors) {
            return reject(errors);
          });
        });
      },
      check: function() {
        var url;
        url = '/api/auth/check';
        return new Ember.RSVP.Promise(function(resolve, reject) {
          return $.get(url).done(function(data) {
            return resolve(data);
          }).fail(function() {
            return resolve(null);
          });
        });
      }
    }
  };
  return me;
});
