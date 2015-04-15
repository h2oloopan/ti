// Generated by CoffeeScript 1.7.1
var exec, fs, handlebars, htmlToText, path, pdfFolder, pdflatex, templateFolder, testTemplateFile, texFolder;

handlebars = require('handlebars');

path = require('path');

fs = require('fs');

exec = require('child_process').exec;

htmlToText = require('html-to-text');

pdfFolder = path.resolve('temp/pdfs');

texFolder = path.resolve('temp/texs');

templateFolder = path.resolve('templates');

testTemplateFile = path.join(templateFolder, 'test.hbs');

pdflatex = module.exports = {
  sanitize: function(test) {
    var html, question, _i, _len, _ref;
    _ref = test.questions;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      question = _ref[_i];
      html = question.question;
      console.log('HTML---------');
      console.log(html);
      question.question = htmlToText.fromString(html);
      console.log('TEXT---------');
      console.log(question.question);
    }
    return test;
  },
  compileTest: function(test, settings, cb) {
    var obj, template, tex, texFile;
    obj = {
      test: this.sanitize(test),
      settings: settings
    };
    obj.settings.preamble = obj.settings.preamble || '';
    template = fs.readFileSync(testTemplateFile);
    template = handlebars.compile(template.toString());
    tex = template(obj);
    texFile = path.join(texFolder, test._id + '.tex');
    return fs.writeFile(texFile, tex, function(err) {
      var cmd;
      if (err) {
        return cb(err);
      } else {
        cmd = 'pdflatex -jobname ' + test._id.toString() + ' -output-directory ' + pdfFolder + ' ' + texFile;
        console.log(cmd);
        return exec(cmd, {
          timeout: 5000
        }, function(err, stdout, stderr) {
          var pdfFile;
          if (err) {
            return cb(err);
          } else {
            pdfFile = path.join(pdfFolder, 'test._id' + '.pdf');
            return cb(null, pdfFile);
          }
        });
      }
    });
  }
};
