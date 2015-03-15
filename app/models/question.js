// Generated by CoffeeScript 1.7.1
var Schema, authorizer, config, folder, fs, me, mkdirp, moment, mv, path, publicFolder, tempFolder;

me = require('mongo-ember');

moment = require('moment');

mv = require('mv');

fs = require('fs');

path = require('path');

mkdirp = require('mkdirp');

Schema = me.Schema;

authorizer = require('../helpers/authorizer');

config = require('../config');

folder = path.resolve(config.image.questionImageFolder);

tempFolder = path.resolve(config.image.tempFolder);

publicFolder = path.resolve('public');

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
      typeTags: {
        type: String
      },
      difficulty: {
        type: Number
      },
      type: {
        type: String
      },
      number: {
        type: Number
      },
      photos: {
        type: [String],
        "default": []
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
        type: String
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
      },
      lastEditor: {
        type: String,
        "default": ''
      },
      lastModifiedTime: {
        type: Date,
        "default": null
      },
      questionLastEditor: {
        type: String,
        "default": ''
      },
      questionLastModifiedTime: {
        type: Date,
        "default": null
      },
      hintLastEditor: {
        type: String,
        "default": ''
      },
      hintLastModifiedTime: {
        type: Date,
        "default": null
      },
      solutionLastEditor: {
        type: String,
        "default": ''
      },
      solutionLastModifiedTime: {
        type: Date,
        "default": null
      },
      summaryLastEditor: {
        type: String,
        "default": ''
      },
      summaryLastModifiedTime: {
        type: Date,
        "default": null
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
      c: function(req, question, user, power, cb) {
        if (power >= 999) {
          return cb(null);
        } else if (user.role.name === 'editor') {
          if (authorizer.canAccessQuestion(user, question)) {
            return cb(null);
          } else {
            return cb(new Error('You do not have the permission to access this'));
          }
        } else {
          return cb(new Error('You do not have the permission to access this'));
        }
      },
      u: function(req, question, user, power, cb) {
        if (power >= 999 || user.role.name === 'editor') {
          if (authorizer.canAccessQuestion(user, question)) {
            return cb(null);
          } else {
            return cb(new Error('You do not have the permission to access this'));
          }
        } else {
          return cb(new Error('You do not have the permission to access this'));
        }
      },
      d: function(req, question, user, power, cb) {
        if (power >= 999) {
          return cb(null);
        } else {
          return cb(new Error('You do not have the permission to access this'));
        }
      },
      ra: function(req, question, user, power, cb) {
        if (power >= 999 || user.role.name === 'editor') {
          return cb(null);
        } else {
          return cb(new Error('You do not have the permission to access this'));
        }
      }
    },
    api: {
      ra: function(req, res, model, form, names) {
        var advanced, err, limit, order, pattern, search, skip, type, _i, _len, _ref;
        advanced = null;
        try {
          advanced = req.query.advanced;
          advanced = JSON.parse(advanced);
        } catch (_error) {
          err = _error;
          advanced = null;
        }
        if (advanced == null) {
          return model.find({}, function(err, result) {
            if (err) {
              return res.send(500, err.message);
            } else {
              return res.send(200, me.helper.wrap(result, names.cname));
            }
          });
        } else {
          console.log(advanced);
          skip = advanced.skip || 0;
          limit = advanced.limit || 1000;
          order = advanced.order || '-';
          search = {};
          if (advanced.school != null) {
            search.school = me.ObjectId(advanced.school);
          }
          if (advanced.subject != null) {
            search.subject = advanced.subject;
          }
          if (advanced.course != null) {
            search.course = advanced.course;
          }
          if ((advanced.types != null) && advanced.types.length > 0) {
            pattern = '';
            _ref = advanced.types;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              type = _ref[_i];
              pattern += type + '|';
            }
            if (pattern.charAt(pattern.length - 1) === '|') {
              pattern = pattern.substr(0, pattern.length - 1);
            }
            search.typeTags = new RegExp('(' + pattern + ')', 'i');
          }
          return model.find(search).count(function(err, count) {
            if (err) {
              return res.send(500, err.message);
            } else {
              return model.find(search).sort(order + '_id').skip(skip).limit(limit).exec(function(err, result) {
                if (err) {
                  return res.send(500, err.message);
                } else {
                  result = me.helper.wrap(result, names.cname);
                  result.count = {
                    number: count
                  };
                  return res.send(200, result);
                }
              });
            }
          });
        }
      }
    },
    before: {
      c: function(question, user, cb) {
        var time, username;
        if (user == null) {
          return cb(new Error('No user is present'));
        } else {
          question.editor = user._id;
          question.question = question.question.trim();
          question.solution = question.solution.trim();
          question.hint = question.hint.trim();
          question.summary = question.summary.trim();
          username = user.username;
          time = moment().toDate();
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
          return cb(null, question);
        }
      },
      u: function(question, user, cb) {
        var Question;
        if (user == null) {
          return cb(new Error('No user is present'));
        } else {
          question.editor = user._id;
          Question = me.getModel('Question');
          return Question.findOne({
            _id: question._id
          }, function(err, oldQuestion) {
            var changed, time, username;
            if (err) {
              return cb(err);
            } else {
              question.question = question.question.trim();
              question.solution = question.solution.trim();
              question.hint = question.hint.trim();
              question.summary = question.summary.trim();
              changed = false;
              username = user.username;
              time = moment().toDate();
              if (question.question !== oldQuestion.question) {
                question.questionLastEditor = username;
                question.questionLastModifiedTime = time;
                changed = true;
              }
              if (question.solution !== oldQuestion.solution) {
                question.solutionLastEditor = username;
                question.solutionLastModifiedTime = time;
                changed = true;
              }
              if (question.hint !== oldQuestion.hint) {
                question.hintLastEditor = username;
                question.hintLastModifiedTime = time;
                changed = true;
              }
              if (question.summary !== oldQuestion.summary) {
                question.summaryLastEditor = username;
                question.summaryLastModifiedTime = time;
                changed = true;
              }
              if (changed) {
                question.lastEditor = username;
                question.lastModifiedTime = time;
              }
              return cb(null, question);
            }
          });
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
        log.save(function(err) {
          if (err) {
            return console.log(err);
          }
        });
        return mkdirp(path.join(folder, question._id.toString()), function(err) {
          var insertPhotos;
          if (err) {
            return cb(err);
          } else {
            insertPhotos = function(question, photos, counter, cb) {
              var destination, location, url;
              if (counter > question.photos.length) {
                return cb(photos);
              }
              url = question.photos[counter - 1];
              location = path.join(publicFolder, url);
              destination = path.join(folder, question._id.toString(), path.basename(url));
              return mv(location, destination, {
                mkdirp: true
              }, function(err) {
                if (err) {
                  console.log(err);
                } else {
                  photos.push(path.relative(publicFolder, destination));
                }
                return insertPhotos(question, photos, counter + 1, cb);
              });
            };
            return insertPhotos(question, [], 1, function(photos) {
              question.photos = photos;
              return question.save(cb);
            });
          }
        });
      },
      ra: function(questions, user, cb) {
        var filter;
        filter = function(question, index) {
          if (authorizer.canAccessQuestion(user, question) && question.flag !== 0) {
            return true;
          } else {
            return false;
          }
        };
        questions = questions.filter(filter);
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
        var Log, log, questionFolder, updatePhotos;
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
        log.save(function(err) {
          if (err) {
            console.log(err);
            return cb(err);
          } else {
            return cb(null, question);
          }
        });
        if ((question.photos == null) || question.photos.length < 1) {
          return cb(null, question);
        }
        updatePhotos = function(question, photos, counter, cb) {
          var destination, location, url;
          if (counter > question.photos.length) {
            return cb(photos);
          }
          url = question.photos[counter - 1];
          location = path.join(publicFolder, url);
          if (location.toLowerCase().indexOf(tempFolder.toLowerCase()) >= 0) {
            destination = path.join(folder, question._id.toString(), path.basename(url));
            console.log(location);
            console.log(destination);
            return mv(location, destination, {
              mkdirp: true
            }, function(err) {
              if (err) {
                console.log('dah');
                console.log(err);
              } else {
                console.log('err');
                photos.push(path.relative(publicFolder, destination));
              }
              return updatePhotos(question, photos, counter + 1, cb);
            });
          } else {
            console.log(url);
            photos.push(url);
            return updatePhotos(question, photos, counter + 1, cb);
          }
        };
        questionFolder = path.join(folder, question._id.toString());
        return fs.readdir(questionFolder, function(err, files) {
          var file, filePath, fileRelativePath, _i, _len;
          if (err) {
            return console.log(err);
          } else {
            for (_i = 0, _len = files.length; _i < _len; _i++) {
              file = files[_i];
              filePath = path.join(questionFolder, file);
              fileRelativePath = path.relative(publicFolder, filePath);
              if (question.photos.indexOf(fileRelativePath) < 0) {
                try {
                  fs.unlinkSync(filePath);
                } catch (_error) {
                  err = _error;
                  console.log(err);
                }
              }
            }
            return updatePhotos(question, [], 1, function(photos) {
              question.photos = photos;
              return question.save(cb);
            });
          }
        });
      }
    }
  }
};
