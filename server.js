'use strict';

var express = require('express'),
    path = require('path'),
    fs = require('fs'),
    mongoose = require('mongoose'),
    mandrill = require('mandrill-api/mandrill'),
    app = express(),
    http = require('http'),
    server = http.createServer(app);

global.io = require('socket.io').listen(server, { log: false });
global.io.configure(function () { 
  io.set("transports", ["xhr-polling"]); 
  io.set("polling duration", 10); 
});

/**
 * Main application file
 */

// Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV || 'development';

// Application Config
var config = require('./lib/config/config');

var mandrill_client = new mandrill.Mandrill(config.mandrill);
global.mandrill = mandrill_client;

// Connect to database
var db = mongoose.connect(config.mongo.uri, config.mongo.options);

// Bootstrap models
var modelsPath = path.join(__dirname, 'lib/models');
require(modelsPath + '/email');
require(modelsPath + '/token');
require(modelsPath + '/user');
require(modelsPath + '/attachment');
require(modelsPath + '/category');
require(modelsPath + '/notification');
require(modelsPath + '/solicitude');
require(modelsPath + '/log');

// Passport Configuration
var passport = require('./lib/config/passport');


var jobs = require('./lib/config/kue')(app);

// Socket.io
global.io.sockets.on('connection', function (sckt) {

  sckt.on('register.notifications', function (data) {
    if (typeof(data) !== 'undefined' && typeof(data.id) !== 'undefined') {
      sckt.join('notifications/'+data.id);
    }
  });

  sckt.on('register.solicitude.change.sla', function(data) {
    sckt.join('solicitude/change/sla');
  });

  sckt.on('register.solicitude.remove.sla', function(data) {
    sckt.join('solicitude/remove/sla');
  });
});

// Populate empty DB with sample data
if (app.get('env') === 'development') {
  require('./lib/config/dummydata');
};

if (app.get('env') === 'test') {
  require('./lib/config/dummydataTest');
};

if (app.get('env') === 'production' && config.dummyDataPro) {
  require('./lib/config/dummydataPro');
};

// Express settings
require('./lib/config/express')(app);

// Routing
require('./lib/routes')(app);

// Start server
server.listen(config.port, function () {
  console.log('Express server listening on port %d in %s mode', config.port, app.get('env'));
});

// Expose app
exports = module.exports = app;
