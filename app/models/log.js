// Generated by CoffeeScript 1.7.1
var Schema;

Schema = require('mongo-ember').Schema;

module.exports = {
  Log: {
    schema: {
      user: {
        type: Schema.Types.ObjectId,
        ref: 'User'
      },
      target: {
        type: String
      },
      operation: {
        type: String
      },
      data: {
        type: Schema.Types.Mixed
      }
    },
    auth: {
      c: function(req, user, power, cb) {
        return cb(new Error('Creating log from api call is not allowed'));
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
        return cb(new Error('Updating log from api call is not allowed'));
      },
      d: function(req, user, power, cb) {
        return cb(new Error('Deleting log from api calls is not allowed'));
      }
    }
  }
};