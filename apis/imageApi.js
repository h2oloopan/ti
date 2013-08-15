// Generated by CoffeeScript 1.6.3
(function() {
  var fs, utils;

  fs = require('fs');

  utils = require('../helpers/utils');

  exports.bind = function(app) {
    return app.get('/api/image/profile/:uid', function(req, res) {
      var path, uid;
      uid = parseInt(req.params.uid);
      if ((req.user != null) && req.user.id === uid) {
        path = utils.image.getProfileImagePath(uid);
        return fs.readFile(path, function(err, data) {
          if (err != null) {
            return res.send(500, err.message);
          } else {
            return res.send(200, data);
          }
        });
      } else {
        return res.send(401, 'Permission denied');
      }
    });
  };

}).call(this);