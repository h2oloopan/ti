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
  var addAdmin, addSchool, addUser;
  addAdmin = function() {
    var model, user;
    user = {
      username: 'span',
      password: encrypt('psy123321'),
      email: 'span@easyace.ca',
      power: 999,
      role: {
        name: 'admin'
      }
    };
    model = me.getModel('User');
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
  addUser = function() {
    var model, user;
    user = {
      username: 'user',
      password: encrypt('123321'),
      email: 'user@easyace.ca',
      power: 10,
      role: {
        name: 'editor'
      }
    };
    model = me.getModel('User');
    return model.findOne({
      username: 'user'
    }, function(err, result) {
      if (err) {
        return console.log(err);
      } else if (result == null) {
        user = new model(user);
        return user.save(function(err, result) {
          if (err) {
            return console.log(err);
          } else {
            return console.log('user user created');
          }
        });
      }
    });
  };
  addSchool = function() {
    var model, school;
    school = {
      name: 'University of Waterloo',
      info: require('./configurations/uwaterloo').info
    };
    model = me.getModel('School');
    return model.findOne({
      name: 'University of Waterloo'
    }, function(err, result) {
      if (err) {
        return console.log(err);
      } else if (result == null) {
        school = new model(school);
        return school.save(function(err, result) {
          if (err) {
            return console.log(err);
          } else {
            return console.log('school UW created');
          }
        });
      } else {
        result.info = school.info;
        return result.save(function(err, result) {
          if (err) {
            return console.log(err);
          } else {
            return console.log('school UW updated');
          }
        });
      }
    });
  };
  addAdmin();
  addUser();
  return addSchool();
};
