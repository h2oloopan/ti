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
        ref: 'School'
      },
      subject: {
        type: String
      },
      term: {
        type: String
      },
      course: {
        type: String
      }
    },
    validationMessages: {
      question: {
        required: 'Question cannot be empty'
      }
    },
    auth: {
      c: function(user, power, cb) {
        return cb(null);
      }
    }
  }
};
