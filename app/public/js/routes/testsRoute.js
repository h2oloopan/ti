// Generated by CoffeeScript 1.7.1
define(['jquery', 'me', 'utils', 'ehbs!templates/tests/tests.index', 'ehbs!templates/tests/tests.new'], function($, me, u) {
  var TestsRoute;
  return TestsRoute = {
    setup: function(App) {
      return App.Router.map(function() {
        return this.resource('tests');
      });
    }
  };
});
