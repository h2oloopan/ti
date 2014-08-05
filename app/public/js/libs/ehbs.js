// Generated by CoffeeScript 1.7.1
define(['module'], function(module) {
  var ehbs;
  ehbs = {
    load: function(name, req, onLoad, config) {
      var compile, path;
      config = config.ehbs || {};
      compile = config.compile || false;
      if (compile) {
        if (config.extension == null) {
          throw "You must provide extension for templates to compile";
        }
        path = name + config.extension;
        return req(['text!' + path], function(value) {
          var lastSlash;
          lastSlash = path.lastIndexOf('/');
          if (lastSlash >= 0) {
            name = path.substr(lastSlash + 1);
          }
          name = name.substr(0, name.length - config.extension.length);
          name = name.replace('.', '/');
          if (path.indexOf('components') >= 0) {
            Ember.TEMPLATES['components/' + name] = Ember.Handlebars.compile(value);
          } else {
            Ember.TEMPLATES[name] = Ember.Handlebars.compile(value);
          }
          return onLoad(value);
        });
      } else {
        return req([name], function(value) {
          return onLoad(value);
        });
      }
    }
  };
  return ehbs;
});