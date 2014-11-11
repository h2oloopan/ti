// Generated by CoffeeScript 1.7.1
var Schema, authorizer, me;

me = require('mongo-ember');

Schema = me.Schema;

authorizer = require('../helpers/authorizer');

module.exports = {
  Question: {
    schema: {
      question: {
        type: String,
        required: true
      },
      hint: {
        type: String
      },
      solution: {
        type: String
      },
      summary: {
        type: String
      },
      note: {
        type: String
      },
      tags: {
        type: String
      },
      difficulty: {
        type: Number
      },
      type: {
        type: String
      },
      flag: {
        type: Number,
        "default": 1
      },
      school: {
        type: Schema.Types.ObjectId,
        ref: 'School',
        required: true
      },
      term: {
        type: String,
        required: true
      },
      subject: {
        type: String,
        required: true
      },
      course: {
        type: String,
        required: true
      },
      editor: {
        type: Schema.Types.ObjectId,
        ref: 'User'
      }
    },
    validationMessages: {
      question: {
        required: 'Question cannot be empty'
      },
      school: {
        required: 'School cannot be empty'
      },
      term: {
        required: 'Term cannot be empty'
      },
      subject: {
        required: 'Subject cannot be empty'
      },
      course: {
        required: 'Course cannot be empty'
      }
    },
    auth: {
      c: function(req, user, power, cb) {
        var question;
        if (power >= 999 || user.role.name === 'editor') {
          question = req.body;
          if (authorizer.canAccessQuestion(user, question)) {
            return cb(null);
          } else {
            return cb(new Error('You do not have the permission to access this'));
          }
        } else {
          return cb(new Error('You do not have the permission to access this'));
        }
      },
      u: function(req, user, power, cb) {
        var question;
        if (power >= 999 || user.role.name === 'editor') {
          question = req.body;
          if (authorizer.canAccessQuestion(user, question)) {
            return cb(null);
          } else {
            return cb(new Error('You do not have the permission to access this'));
          }
        } else {
          return cb(new Error('You do not have the permission to access this'));
        }
      },
      d: function(req, user, power, cb) {
        if (power >= 999) {
          return cb(null);
        } else {
          return cb(new Error('You do not have the permission to access this'));
        }
      }
    },
    before: {
      c: function(question, user, cb) {
        if (user == null) {
          return cb(new Error('No user is present'));
        } else {
          question.editor = user._id;
          return cb(null, question);
        }
      },
      u: function(question, user, cb) {
        if (user == null) {
          return cb(new Error('No user is present'));
        } else {
          question.editor = user._id;
          return cb(null, question);
        }
      }
    },
    after: {
      c: function(question, user, cb) {
        var Log, log;
        if (user == null) {
          console.log('Something is wrong, question created without user');
          return cb(new Error('Question created without user'));
        }
        Log = me.getModel('Log');
        log = new Log({
          user: user._id,
          target: 'question',
          operation: 'create',
          data: {
            question: question.toObject()
          }
        });
        return log.save(function(err) {
          if (err) {
            console.log(err);
            return cb(err);
          } else {
            return cb(null, question);
          }
        });
      },
      ra: function(questions, user, cb) {
        var question, _i, _len;
        for (_i = 0, _len = questions.length; _i < _len; _i++) {
          question = questions[_i];
          if (!authorizer.canAccessQuestion(user, question)) {
            questions.removeObject(question);
          }
        }
        return cb(null, questions);
      },
      ro: function(question, user, cb) {
        if (!authorizer.canAccessQuestion(user, question)) {
          return cb(new Error('You do not have the permission to access this'));
        } else {
          return cb(null, question);
        }
      },
      u: function(question, user, cb) {
        var Log, log;
        if (user == null) {
          console.log('Something is wrong, question updated without user');
          return cb(new Error('Question updated without user'));
        }
        Log = me.getModel('Log');
        log = new Log({
          user: user._id,
          target: 'question',
          operation: 'update',
          data: {
            question: question.toObject()
          }
        });
        return log.save(function(err) {
          if (err) {
            console.log(err);
            return cb(err);
          } else {
            return cb(null, question);
          }
        });
      }
    }
  }
};
