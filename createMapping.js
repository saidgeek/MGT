'use strict'

var config = require('./lib/config/config'),
    mongoose = require('mongoose'),
    mongoose.connect(config.mongo.uri, config.mongo.options),
    path = require('path'),
    mongoosastic = require('mongoosastic');

var modelsPath = path.join(__dirname, 'lib/models');
require(modelsPath + '/email');
require(modelsPath + '/token');
require(modelsPath + '/user');
require(modelsPath + '/attachment');
require(modelsPath + '/category');
require(modelsPath + '/notification');
require(modelsPath + '/solicitude');
require(modelsPath + '/task');
require(modelsPath + '/comment');
require(modelsPath + '/log');

Solicitude = mongoose.model('Solicitude');

Solicitude.createMapping(function(err, mapping) {
  if (err) {
    console.log('err:', err);
  } else {
    console.log('Mapping creado');
    console.log(mapping);
  };
});

var stream = Solicitude.synchronize();
  var count = 0;

  stream.on('data', function(err, doc) {
    count++;
  });

  stream.on('close', function() {
    console.log('Indexados '+ count + ' solicitudes!');
  });

  stream.on('error', function(err) {
    console.log('ERROR:', err);
  });