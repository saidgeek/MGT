'use strict'

var path = require('path'),
    mongoose = require('mongoose'),
    mongoosastic = require('mongoosastic'),
    Solicitude = mongoose.model('Solicitude');

module.exports = function() {
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
};
