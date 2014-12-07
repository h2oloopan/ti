var express = require('express');
var session = require('express-session');
var multer = require('multer');
var path = require('path');
var favicon = require('static-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var fs = require('fs');
var me = require('mongo-ember');
var initializer = require('./initializer');



var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(favicon());
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded());
app.use(multer({dest: './temp/exchange'}));
app.use(cookieParser());
app.use(session({secret: 'app&test%', name: 'sid'}));
app.use(express.static(path.join(__dirname, 'public')));


//doing my stuff here
me.setup({
    modelsFolder: path.join(__dirname, 'models'),
    namespace: 'api',
    connectionString: 'mongodb://localhost/ti',
    mePath: '/js/libs/me.js',
    meOutputPath: path.join(__dirname, 'public/js/libs/me.js'),
    primaryKey: '_id',
    userModel: 'User',
    optimize: {
        minifyJS: true,
        compileHandlebars: false,
        publicFolder: path.join(__dirname, 'public'),
        excludePath: ['libs', 'templates', 'MathJax'],
        templatePath: 'templates',
        templateExtension: '.html'
    }
}).init(app, initializer.init);


app.get('/', function(req, res) {
    fs.readFile(path.resolve('index.html'), {encoding: 'utf8'}, function (err, data){
        if (err) {
            res.send(500, err.message);
        }
        else {
            res.send(200, data);
        }
    });
});




/*
/// catch 404 and forward to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

/// error handlers

// development error handler
// will print stacktrace

if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
        message: err.message,
        error: {}
    });
});
*/

module.exports = app;
