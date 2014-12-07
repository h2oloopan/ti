// Generated by CoffeeScript 1.7.1
require.config({
  baseUrl: '/js/libs',
  ehbs: {
    compile: true,
    extension: '.html'
  },
  paths: {
    templates: '/templates',
    routes: '/js/routes',
    app: '/js/app',
    mj: '/js/MathJax'
  },
  shim: {
    'bootstrap': ['jquery'],
    'jquery.hotkeys': ['jquery'],
    'jquery.cookie': ['jquery'],
    'bootstrap-wysiwyg': ['bootstrap', 'jquery', 'jquery.hotkeys'],
    'ember': ['handlebars', 'jquery'],
    'ember-data': ['ember'],
    'jquery.fileupload': ['jquery', 'jquery.ui.widget', 'jquery.iframe-transport'],
    'app': ['ember', 'ember-data', 'bootstrap', 'jquery.cookie', 'moment']
  }
});

require(['app'], function(app) {
  return app.start();
});
