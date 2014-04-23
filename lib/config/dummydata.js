'use strict';

var mongoose = require('mongoose'),
  User = mongoose.model('User'),
  Token = mongoose.model('Token');

/**
 * Populate database with sample application data
 */


// Clear old users, then add a default user
User.findOne({email: 'atarix.010101@gmail.com'}, function(err, user) {

  if (!user) {
    var token = new Token({
        description: 'Token test',
        token: true
      });
      token.save(function(err){

        User.create({
          role: 'ROOT',
          provider: 'local',
          email: 'atarix.010101@gmail.com',
          profile: {
            firstName: 'Andrés',
            lastName: 'Espinace',
            description: 'Tests user',
            phoneNumber: '00000000'
          },
          access: token.info
        }, function() {
            console.log('finished populating users');
          });

      });
  }

});

User.findOne({email: 'nestor@grupoingenia.cl'}, function(err, user) {

  if (!user) {
    var token = new Token({
        description: 'Token test',
        token: true
      });
      token.save(function(err){

        User.create({
          role: 'ROOT',
          provider: 'local',
          email: 'nestor@grupoingenia.cl',
          profile: {
            firstName: 'Andrés',
            lastName: 'Espinace',
            description: 'Tests user',
            phoneNumber: '00000000'
          },
          access: token.info
        }, function() {
            console.log('finished populating users');
          });

      });
  }

});
