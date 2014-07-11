'use strict'

var path = require('path'),
    mongoose = require('mongoose'),
    mongoosastic = require('mongoosastic'),
    Solicitude = mongoose.model('Solicitude');

module.exports = function() {

  var Solicitude = mongoose.model('Solicitude');

  Solicitude.createMapping(function(err, mapping) {
    if (err) {
      console.log('err:', err);
    } else {
      console.log('Mapping creado');
      console.log(mapping);
    };
  });
  
};
