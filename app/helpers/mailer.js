// Generated by CoffeeScript 1.7.1
var config, fs, mailer, nm, path, template_registration, transporter;

nm = require('nodemailer');

path = require('path');

fs = require('fs');

config = require('../config');

template_registration = path.resolve('helpers/mailTemplates/registration.html');

transporter = nm.createTransport({
  service: 'Gmail',
  auth: {
    user: 'span@easyace.ca',
    pass: 'psy123321'
  }
});

mailer = module.exports = {
  sendMail: function(to, subject, content, cb) {
    var options;
    options = {
      from: 'EasyAce',
      to: to,
      subject: subject,
      html: content
    };
    return transporter.sendMail(options, cb);
  },
  sendRegistrationMail: function(user, cb) {
    var prepare;
    prepare = function(template) {
      var content;
      content = template.replace('{{username}}', user.username).replace('{{password}}', user.password).replace('{{url}}', config.url);
      return content;
    };
    return fs.readFile(template_registration, {
      encoding: 'utf8'
    }, function(err, template) {
      var content;
      if (err) {
        return cb(err);
      } else {
        content = prepare(template);
        return mailer.sendMail(user.email, 'EasyAce Registration Completed', content, cb);
      }
    });
  }
};
