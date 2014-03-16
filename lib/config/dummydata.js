'use strict';

var mongoose = require('mongoose'),
  User = mongoose.model('User'),
  Token = mongoose.model('Token');

/**
 * Populate database with sample application data
 */


// Clear old users, then add a default user
Token.find({}).remove(function(){
  var token = new Token({
    description: 'Token test',
    token: true
  });
  token.save(function(err){
    User.find({}).remove(function() {
      User.create({
        provider: 'local',
        email: 'test@test.com',
        password: 'test',
        profile: {
          firstName: 'Fake',
          lastName: 'Test',
          description: 'Tests user',
          phoneNumber: '00000000'
        },
        access: token.info
      }, function() {
          console.log('finished populating users');
        }
      );
    });
  });
});
