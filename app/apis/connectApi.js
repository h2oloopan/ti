// Generated by CoffeeScript 1.7.1
var config, jwt, me, path;

me = require('mongo-ember');

jwt = require('jsonwebtoken');

config = require('../config');

path = require('path');

exports.bind = function(app) {
  app.post('/api/connect/questions/create', function(req, res) {
    var question, token;
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'X-Requested-With');
    question = req.body.question;
    token = req.body.token;
    return jwt.verify(token, config.secret, function(err, user) {
      var School, pattern;
      if (err) {
        return res.send(401, 'You do not have the permission to access this api');
      } else {
        req.session[config.sessionKey] = user._id.toString();
        if (question.school == null) {
          return res.send(404, 'Question must have an associated school');
        }
        School = me.getModel('School');
        pattern = new RegExp('^' + question.school + '$', 'ig');
        return School.findOne({
          name: pattern
        }, function(err, school) {
          var Question, time, username;
          if (err) {
            return res.send(500, err.message);
          } else if (school == null) {
            return res.send(404, 'Invalid school for given question');
          } else {
            Question = me.getModel('Question');
            question = new Question(question);
            username = user.username;
            time = moment().toDate();
            question.editor = user._id;
            question.lastEditor = username;
            question.lastModifiedTime = time;
            question.questionLastEditor = username;
            question.questionLastModifiedTime = time;
            question.solutionLastEditor = username;
            question.solutionLastModifiedTime = time;
            question.hintLastEditor = username;
            question.hintLastModifiedTime = time;
            question.summaryLastEditor = username;
            question.summaryLastModifiedTime = time;
            return question.save(function(err, question) {
              if (err) {
                return res.send(500, err.message);
              } else {
                return res.send(200, path.join(config.url, '#/question/' + question._id + '/edit').toString());
              }
            });
          }
        });
      }
    });
  });
  return app.post('/api/connect/auth', function(req, res) {
    var password, user, username;
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'X-Requested-With');
    username = req.body.username;
    password = req.body.password;
    user = {
      username: username,
      password: password
    };
    return me.authenticate(user, function(err, user) {
      var token;
      if (err) {
        return res.send(401, err.message);
      } else {
        token = jwt.sign(user, config.secret);
        req.session[config.sessionKey] = user._id.toString();
        return res.send(200, token);
      }
    });
  });
};
