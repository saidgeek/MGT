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
    User.findOne({email: 'atarix.010101@gmail.com'}, function(err, user) {
      if (!user) {
        User.create({
          role: 'SUDO',
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
          }
        );
      };
    });
    // hanns@grupoingenia.cl
    User.findOne({email: 'hanns@grupoingenia.cl'}, function(err, user) {
      if (!user) {
        User.create({
          role: 'SUDO',
          provider: 'local',
          email: 'hanns@grupoingenia.cl',
          profile: {
            firstName: 'Hanns',
            lastName: 'Peña',
            description: 'Tests user',
            phoneNumber: '00000000'
          },
          access: token.info
        }, function() {
            console.log('finished populating users');
          }
        );
      };
    });

    // Amir Pedram - amir.pedram@telefonica.com - Admin
    User.findOne({email: 'amir.pedram@telefonica.com'}, function(err, user) {
      if (!user) {
        User.create({
          role: 'Admin',
          provider: 'local',
          email: 'amir.pedram@telefonica.com',
          profile: {
            firstName: 'Amir',
            lastName: 'Pedram',
            description: 'Tests user',
            phoneNumber: '00000000'
          },
          access: token.info
        }, function() {
            console.log('finished populating users');
          }
        );
      };
    });

    // Christopher Herrera - christopher@grupoingenia.cl - Editor
    User.findOne({email: 'christopher@grupoingenia.cl'}, function(err, user) {
      if (!user) {
        User.create({
          role: 'Editor',
          provider: 'local',
          email: 'christopher@grupoingenia.cl',
          profile: {
            firstName: 'Christopher',
            lastName: 'Herrera',
            description: 'Tests user',
            phoneNumber: '00000000'
          },
          access: token.info
        }, function() {
            console.log('finished populating users');
          }
        );
      };
    });

    // Bárbara Santander - barbara@grupoingenia.cl - Gestor
    User.findOne({email: 'barbara@grupoingenia.cl'}, function(err, user) {
      if (!user) {
        User.create({
          role: 'Gestor',
          provider: 'local',
          email: 'barbara@grupoingenia.cl',
          profile: {
            firstName: 'Bárbara',
            lastName: 'Santander',
            description: 'Tests user',
            phoneNumber: '00000000'
          },
          access: token.info
        }, function() {
            console.log('finished populating users');
          }
        );
      };
    });

    // Loredana Rojas - loredana@grupoingenia.cl - Gestor
    User.findOne({email: 'loredana@grupoingenia.cl'}, function(err, user) {
      if (!user) {
        User.create({
          role: 'Gestor',
          provider: 'local',
          email: 'loredana@grupoingenia.cl',
          profile: {
            firstName: 'Loredana',
            lastName: 'Rojas',
            description: 'Tests user',
            phoneNumber: '00000000'
          },
          access: token.info
        }, function() {
            console.log('finished populating users');
          }
        );
      };
    });

    // Carolina Fritz - caro.fritz@grupoingenia.cl - Gestor
    User.findOne({email: 'caro.fritz@grupoingenia.cl'}, function(err, user) {
      if (!user) {
        User.create({
          role: 'Gestor',
          provider: 'local',
          email: 'caro.fritz@grupoingenia.cl',
          profile: {
            firstName: 'Carolina',
            lastName: 'Fritz',
            description: 'Tests user',
            phoneNumber: '00000000'
          },
          access: token.info
        }, function() {
            console.log('finished populating users');
          }
        );
      };
    });












  });