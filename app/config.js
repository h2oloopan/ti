var config;

config = module.exports = {
  url: 'http://ti.easyace.ca',
  secret: 'xxx679',
  sessionKey: 'x768me&^',
  image: {
  	tempFolder: 'public/temp',
  	questionImageFolder: 'public/images/questions',
  	width: 1280,
  	height: 960,
  	quality: 80,
  	format: '.gif'
  },
  tests: {
    templatePath: 'templates/test.hbs'
  },
  download: {
    pdfFolder: 'temp/pdfs'
  },
  admin: {
    power: 999
  }
};
