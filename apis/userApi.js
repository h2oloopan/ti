// Generated by CoffeeScript 1.6.3
(function() {
  var User;

  User = require('../models/user');

  exports.bind = function(app) {
    return app.get('/api/users/self', function(req, res) {
      if (req.user != null) {
        return res.send(200, req.user);
      } else {
        return res.send(401, 'Permission denied');
      }
    });
  };

}).call(this);
