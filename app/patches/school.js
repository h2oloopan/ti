// Generated by CoffeeScript 1.8.0
var fs, me, modelFolder, path;

require('array.prototype.find');

me = require('mongo-ember');

fs = require('fs');

path = require('path');

modelFolder = path.resolve('../models');

me.loadModels(modelFolder);

me.connect({}, 'mongodb://localhost/ti', function(app) {
  var School;
  School = me.getModel('School');
  return School.findOne({
    name: 'University of Waterloo'
  }, function(err, school) {
    var actual, course, courses, found, stuff, subject, subjects, term, terms, _i, _j, _k, _len, _len1, _len2, _ref;
    if (err) {
      return console.log(err);
    } else {
      stuff = school.toJSON().info;
      if (stuff.terms == null) {
        return false;
      }
      actual = {
        subjects: new Array()
      };
      terms = [];
      _ref = stuff.terms;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        term = _ref[_i];
        if (terms.indexOf(term.name) < 0) {
          terms.push(term.name);
        }
        subjects = term.subjects;
        for (_j = 0, _len1 = subjects.length; _j < _len1; _j++) {
          subject = subjects[_j];
          courses = subject.courses;
          for (_k = 0, _len2 = courses.length; _k < _len2; _k++) {
            course = courses[_k];
            found = actual.subjects.find(function(item) {
              if (item.name === subject.name) {
                return true;
              }
              return false;
            });
            if (found == null) {
              found = {
                name: subject.name,
                courses: []
              };
              found.courses.push(course);
              actual.subjects.push(found);
            } else {
              found.courses.push(course);
            }
          }
        }
      }
      school.info = actual;
      school.terms = terms;
      return school.save(function(err) {
        if (err) {
          return console.log(err);
        }
      });
    }
  });
});
