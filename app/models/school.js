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
      terms: {
        type: [String]
      },
      types: {
        type: [String]
      },
      info: {
        type: Schema.Types.Mixed,
        "default": {
          subjects: []
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
      c: function(req, school, user, power, cb) {
        if (power >= 999) {
          return cb(null);
        } else {
          return cb(new Error('You do not have the permission to access this'));
        }
      },
      ra: function(req, school, user, power, cb) {
        if (user != null) {
          return cb(null);
        } else {
          return cb(new Error('You do not have the permission to access this'));
        }
      },
      u: function(req, school, user, power, cb) {
        if (power >= 999) {
          return cb(null);
        } else {
          return cb(new Error('You do not have the permission to access this'));
        }
      },
      d: function(req, school, user, power, cb) {
        if (power >= 999) {
          return cb(null);
        } else {
          return cb(new Error('You do not have the permission to access this'));
        }
      }
    },
    after: {
      ra: function(schools, user, cb) {
        var filter, privilege, school, subject, _i, _j, _k, _len, _len1, _len2, _ref, _ref1;
        if (user.power >= 999) {
          return cb(null, schools);
        } else {
          schools = schools.map(function(school) {
            return school.toObject();
          });
          _ref = user.privileges;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            privilege = _ref[_i];
            filter = function(set, subsets, fields, rules, counter, max) {
              var field, filterSet, rule;
              field = fields[counter];
              rule = privilege[rules[counter]];
              if ((rule != null) && rule.length > 0) {
                filterSet = function(item) {
                  if (item[field].toString().trim().toLowerCase() === rule.trim().toLowerCase()) {
                    item.selected = true;
                    if (counter <= max) {
                      if (counter === 0) {
                        filter(item.info[subsets[counter + 1]], subsets, fields, rules, counter + 1, max);
                      } else {
                        filter(item[subsets[counter + 1]], subsets, fields, rules, counter + 1, max);
                      }
                    }
                  }
                  return true;
                };
                return set = set.filter(filterSet);
              } else {
                filterSet = function(item) {
                  item.selected = true;
                  if (counter <= max) {
                    if (counter === 0) {
                      filter(item.info[subsets[counter + 1]], subsets, fields, rules, counter + 1, max);
                    } else {
                      filter(item[subsets[counter + 1]], subsets, fields, rules, counter + 1, max);
                    }
                  }
                  return true;
                };
                return set = set.filter(filterSet);
              }
            };
            filter(schools, ['', 'subjects', 'courses'], ['_id', 'name', 'number'], ['school', 'subject', 'course'], 0, 1);
          }
          for (_j = 0, _len1 = schools.length; _j < _len1; _j++) {
            school = schools[_j];
            _ref1 = school.info.subjects;
            for (_k = 0, _len2 = _ref1.length; _k < _len2; _k++) {
              subject = _ref1[_k];
              subject.courses = subject.courses.filter(function(course) {
                if (course.selected) {
                  return true;
                }
                return false;
              });
            }
            school.info.subjects = school.info.subjects.filter(function(subject) {
              if (subject.selected) {
                return true;
              }
              return false;
            });
          }
          schools = schools.filter(function(school) {
            if (school.selected) {
              return true;
            }
            return false;
          });
          return cb(null, schools);
        }
      }
    }
  }
};
