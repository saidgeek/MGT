'use strict';

var mongoose = require('mongoose'),
  User = mongoose.model('User'),

/**
 * Populate database with sample application data
 */


// Clear old users, then add a default user
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
    }
  }, function() {
      console.log('finished populating users');
    }
  );
});
