// Generated by CoffeeScript 1.7.1
var crypto, encrypt, me;

crypto = require('crypto');

me = require('mongo-ember');

encrypt = function(input) {
  var sha;
  sha = crypto.createHash('sha256');
  sha.update(input);
  return sha.digest('hex').toString();
};

exports.init = function() {
  var addAdmin;
  addAdmin = function() {
    var model, user;
    user = {
      username: 'span',
      password: encrypt('psy123321'),
      email: 'span@easyace.ca',
      power: 999
    };
    model = me.getModel['User'];
    console.log(model);
    return model.findOne({
      username: 'span'
    }, function(err, result) {
      if (err) {
        return console.log(err);
      } else if (result == null) {
        user = new model(user);
        return user.save(function(err, result) {
          if (err) {
            return console.log(err);
          } else {
            return console.log('admin span created');
          }
        });
      }
    });
  };
  return setTimeout(addAdmin, 3000);
};
