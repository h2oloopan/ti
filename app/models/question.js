// Generated by CoffeeScript 1.7.1
var Schema, authorizer, config, folder, fs, me, mkdirp, mv, path, publicFolder, tempFolder;

me = require('mongo-ember');

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
      difficulty: {
        type: Number
      },
      type: {
        type: String
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
        log.save(function(err) {
          if (err) {
            return console.log(err);
          }
        });
        return mkdirp(path.join(folder, question._id.toString()), function(err) {
          var destination, location, photos, url, _i, _len, _ref;
          if (err) {
            return cb(err);
          } else {
            photos = [];
            _ref = question.photos;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              url = _ref[_i];
              location = path.join(publicFolder, url);
              destination = path.join(folder, question._id.toString(), path.basename(url));
              try {
                fs.renameSync(location, destination);
                photos.push(path.relative(publicFolder, destination));
              } catch (_error) {
                err = _error;
                console.log(err);
              }
            }
            question.photos = photos;
            return question.save(cb);
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
        var Log, destination, err, file, filePath, fileRelativePath, files, location, log, photos, questionFolder, url, _i, _j, _len, _len1, _ref;
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
        photos = [];
        _ref = question.photos;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          url = _ref[_i];
          location = path.join(publicFolder, url);
          if (location.toLowerCase().indexOf(tempFolder.toLowerCase()) >= 0) {
            destination = path.join(folder, question._id.toString(), path.basename(url));
            console.log(location);
            console.log(destination);
            mv(location, destination, {
              mkdirp: true
            }, function(err) {
              if (err) {
                return console.log(err);
              } else {
                console.log('reaching here');
                return photos.push(path.relative(publicFolder, destination));
              }
            });
          } else {
            photos.push(url);
          }
        }
        questionFolder = path.join(folder, question._id.toString());
        files = fs.readdirSync(questionFolder);
        for (_j = 0, _len1 = files.length; _j < _len1; _j++) {
          file = files[_j];
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
        question.photos = photos;
        return question.save(cb);
      }
    }
  }
};
