'use strict'

var path = require('path'),
    mongoose = require('mongoose'),
    mongoosastic = require('mongoosastic');

var db = mongoose.connect('mongodb://localhost/movistar-dev');

var modelsPath = path.join(__dirname, 'lib/models');
require(modelsPath + '/email');
require(modelsPath + '/token');
require(modelsPath + '/user');
require(modelsPath + '/attachment');
require(modelsPath + '/category');
require(modelsPath + '/notification');
require(modelsPath + '/task');
require(modelsPath + '/comment');
require(modelsPath + '/solicitude');
require(modelsPath + '/log');

var Solicitude = mongoose.model('Solicitude');

Solicitude.createMapping(function(err, mapping) {
  if (err) {
    console.log('err:', err);
  } else {
    console.log('Mapping creado');
    console.log(mapping);
  };
});