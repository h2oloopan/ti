// Generated by CoffeeScript 1.8.0
var fs, me, modelFolder, path;

require('array.prototype.find');

me = require('mongo-ember');

fs = require('fs');

path = require('path');

modelFolder = path.resolve('../models');

me.loadModels(modelFolder);

me.connect({}, 'mongodb://localhost/ti', function(app) {
  var Question;
  Question = me.getModel('Question');
  return Question.find({}, function(err, questions) {
    var question, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = questions.length; _i < _len; _i++) {
      question = questions[_i];
      _results.push((function(question) {
        var term, type;
        term = question.term;
        type = question.type;
        if ((term != null) && term.length > 0 && (type != null) && type.length > 0) {
          question.typeTags = term + ' ' + type;
          return question.save();
        }
      })(question));
    }
    return _results;
  });
});