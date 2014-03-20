'use strict';

var express = require('express'),
    path = require('path'),
    fs = require('fs'),
    mongoose = require('mongoose'),
    mandrill = require('mandrill-api/mandrill'),
    mandrill_client = new mandrill.Mandrill('9cyYwqPH5H0YbKF1zjUvpg');

global.mandrill = mandrill_client;

/**
 * Main application file
 */

// Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV || 'development';

// Application Config
var config = require('./lib/config/config');

// Connect to database
var db = mongoose.connect(config.mongo.uri, config.mongo.options);

// Bootstrap models
var modelsPath = path.join(__dirname, 'lib/models');
require(modelsPath + '/token');
require(modelsPath + '/user');
require(modelsPath + '/attachment');
require(modelsPath + '/category');
require(modelsPath + '/notification');
require(modelsPath + '/report');
require(modelsPath + '/solicitude');
var Email = require(modelsPath + '/email');
// fs.readdirSync(modelsPath).forEach(function (file) {
//   if (/(.*)\.(js$|coffee$)/.test(file)) {
//     require(modelsPath + '/' + file);
//   }
// });
  
// Passport Configuration
var passport = require('./lib/config/passport');

var app = express();

var jobs = require('./lib/config/kue')(app);

// Populate empty DB with sample data
if (app.get('env') === 'development' || app.get('env') === 'test') {
  require('./lib/config/dummydata');
};

// Express settings
require('./lib/config/express')(app);

// Routing
require('./lib/routes')(app);

// Start server
app.listen(config.port, function () {
  console.log('Express server listening on port %d in %s mode', config.port, app.get('env'));
});

// Expose app
exports = module.exports = app;