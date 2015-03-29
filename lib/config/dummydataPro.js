'use strict';

var mongoose = require('mongoose'),
  User = mongoose.model('User'),
  Token = mongoose.model('Token');

/**
 * Populate database with sample application data
 */


// Clear old users, then add a default user
var token = new Token({
    description: 'Token test',
    token: true
  });
  token.save(function(err){
    User.findOne({email: 'andres.espinace@fusiona.cl'}, function(err, user) {
      if (!user) {
        User.create({
          role: 'ROOT',
          provider: 'local',
          email: 'andres.espinace@fusiona.cl',
          profile: {
            firstName: 'Andres',
            lastName: 'Espinace',
            description: 'Usuario super administrador',
            phoneNumber: ''
          },
          access: token.info
        }, function() {
            console.log('finished populating users');
          }
        );
      };
    });













  });