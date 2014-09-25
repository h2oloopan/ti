// Generated by CoffeeScript 1.7.1
var Schema;

Schema = require('mongo-ember').Schema;

module.exports = {
  User: {
    schema: {
      username: {
        type: String,
        required: true,
        match: /^[A-Z0-9\._-]+$/i
      },
      password: {
        type: String,
        required: true
      },
      email: {
        type: String,
        required: true,
        match: /^[A-Z0-9\._%+-]+@[A-Z0-9\.-]+\.[A-Z]{2,4}$/i
      },
      power: {
        type: Number,
        "default": 1
      },
      role: {
        type: Schema.Types.Mixed,
        "default": {}
      }
    },
    validationMessages: {
      username: {
        required: 'Username cannot be empty',
        match: 'Invalid username'
      },
      password: {
        required: 'Password cannot be empty'
      },
      email: {
        required: 'Email cannot be empty',
        match: 'Invalid email address'
      }
    },
    auth: {
      c: function(req, user, power, cb) {
        if (power >= 999) {
          return cb(null);
        } else {
          return cb(new Error('You do not have the permission to access this'));
        }
      },
      ra: function(req, user, power, cb) {
        if (power >= 999) {
          return cb(null);
        } else {
          return cb(new Error('You do not have the permission to access this'));
        }
      },
      ro: function(req, user, power, cb) {
        if (power >= 999) {
          return cb(null);
        } else {
          return cb(new Error('You do not have the permission to access this'));
        }
      },
      u: function(req, user, power, cb) {
        if (power >= 999) {
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
    }
  }
};
