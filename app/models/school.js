// Generated by CoffeeScript 1.7.1
var Schema;

Schema = require('mongo-ember').Schema;

module.exports = {
  School: {
    schema: {
      name: {
        type: String,
        required: true
      },
      info: {
        type: Schema.Types.Mixed,
        "default": {
          terms: []
        }
      }
    },
    validationMessages: {
      name: {
        required: 'School name cannot be empty'
      }
    },
    api: {
      c: function(req, res, model, form, cb) {
        var school;
        school = new model(form);
        return school.validate(function(err) {
          var pattern;
          if (err) {
            return cb(err);
          } else {
            pattern = new RegExp('^' + school.name + '$', 'i');
            return model.findOne({
              name: pattern
            }, function(err, result) {
              if (err) {
                return cb(err);
              } else if (result != null) {
                return cb(new Error('School ' + school.name + ' was already in the database'));
              } else {
                return school.save(function(err, result) {
                  if (err) {
                    return cb(err);
                  } else {
                    return cb(null, {
                      code: 201,
                      data: result
                    });
                  }
                });
              }
            });
          }
        });
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
    },
    after: {
      ra: function(schools, user, cb) {
        if (power >= 999) {
          return cb(null, schools);
        } else {
          return cb(null, schools);

          /*
          					filter = (school, index) ->
          						for privilege in user.privileges
          							if privilege.school? and privilege.school != school then continue
          							info = school.info
          							for term in info.terms
          								if privilege.term? and privilege.term != term then continue
          								for subject in term.subjects
          									if privilege.subject? and privilege.subject != subject then continue
          									for course in subject.courses
          										if privilege.course? and privilege.course != course then continue
           */
        }
      }
    }
  }
};
