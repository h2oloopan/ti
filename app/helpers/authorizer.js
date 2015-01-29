// Generated by CoffeeScript 1.8.0
var authorizer;

authorizer = module.exports = {
  canAccessQuestion: function(user, question) {
    var exist, privilege, _i, _len, _ref;
    if (user.power >= 999) {
      return true;
    }
    exist = function(something) {
      if ((something != null) && something.length > 0) {
        return true;
      }
      return false;
    };
    _ref = user.privileges;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      privilege = _ref[_i];
      if (exist(privilege.school) && privilege.school.trim().toLowerCase() !== question.school.toString().trim().toLowerCase()) {
        continue;
      }
      if (exist(privilege.subject) && privilege.subject.trim().toLowerCase() !== question.subject.trim().toLowerCase()) {
        continue;
      }
      if (exist(privilege.course) && privilege.course.trim().toLowerCase() !== question.course.trim().toLowerCase()) {
        continue;
      }
      return true;
    }
    return false;
  }
};
