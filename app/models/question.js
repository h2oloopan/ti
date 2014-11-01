// Generated by CoffeeScript 1.7.1
var Schema;

Schema = require('mongo-ember').Schema;

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
        if (power >= 999 || user.role.name === 'editor') {
          return cb(null);
        } else {
          return cb(new Error('You do not have the permission to access this'));
        }
      },
      u: function(req, user, power, cb) {
        if (power >= 999 || user.role.name === 'editor') {
          return cb(null);
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
          return cb(null, obj);
        }
      },
      u: function(question, user, cb) {
        if (user == null) {
          return cb(new Error('No user is present'));
        } else {
          question.editor = user._id;
          return cb(null, obj);
        }
      }
    }
  }
};
