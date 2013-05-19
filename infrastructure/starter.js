(function() {
  var apiFolder, apply, fs, patchFolder, patchPrefix, path, versionFile;

  path = require('path');

  fs = require('fs');

  apiFolder = path.resolve('apis');

  patchFolder = path.resolve('patches');

  versionFile = path.resolve('version.json');

  patchPrefix = 'p';

  exports.start = function(app, cb) {
    var api, files, patch, patchNumber, patches, version, _i, _j, _len, _len1;

    files = fs.readdirSync(apiFolder);
    for (_i = 0, _len = files.length; _i < _len; _i++) {
      api = files[_i];
      if (path.extname(api) === '.js') {
        (require(path.join(apiFolder, api))).bind(app);
      }
    }
    if (fs.existsSync(versionFile)) {
      version = fs.readFileSync(versionFile).toString();
      patchNumber = JSON.parse(version).patch;
    } else {
      patchNumber = 0;
    }
    console.log('System was at patch ' + patchNumber);
    patches = [];
    files = fs.readdirSync(patchFolder);
    for (_j = 0, _len1 = files.length; _j < _len1; _j++) {
      patch = files[_j];
      if (path.extname(patch) === '.js') {
        patches.push(patch);
      }
    }
    return apply(patches, patchNumber + 1, cb);
  };

  apply = function(patches, next, cb) {
    var patch;

    patch = patchPrefix + next + '.js';
    if (patches.indexOf(patch) < 0) {
      fs.writeFileSync(versionFile, JSON.stringify({
        patch: next - 1
      }));
      console.log('System is now at patch ' + (next - 1));
      return cb();
    } else {
      console.log('Applying patch ' + patch + '...');
      return (require(path.join(patchFolder, patch))).apply(function(err) {
        if (err) {
          fs.writeFileSync(versionFile, JSON.stringify({
            patch: next - 1
          }));
          console.log('Failed at patch ' + next);
          return cb(err);
        } else {
          return apply(patches, next + 1, cb);
        }
      });
    }
  };

}).call(this);
