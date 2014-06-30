'use strict';

var mongoose = require('mongoose'),
  User = mongoose.model('User'),
  Token = mongoose.model('Token'),
  Log = mongoose.model('Log');

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

// Log.find()
//   .exec(function(err, logs) {
//     if (!err) {

//       for (var i = 0; i < logs.length; i++) {

//         if (typeof(logs[i].data) === 'undefined' || logs[i].data === null || logs[i].data.length === 0) {

//           var db = mongoose.model(logs[i]._class);
//           var log = logs[i];

//           console.log('dummyData db:', db);

//           db.findById( log._classId )
//             .exec(function(err, data) {
//               console.log('dummyData data:', err, data);
//               if (!err) {

//                 console.log('dummyData log:', log);

//                 log.data = data;
//                 log.save();

//               };
//             });

//         };

//       };

//     };
//   });
