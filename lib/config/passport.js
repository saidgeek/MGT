'use strict';

var mongoose = require('mongoose'),
    User = mongoose.model('User'),
    passport = require('passport'),
    LocalStrategy = require('passport-local').Strategy;

/**
 * Passport configuration
 */
passport.serializeUser(function(user, done) {
  done(null, user.id);
});
passport.deserializeUser(function(id, done) {
  User.findOne({
    _id: id
  }, '-salt -hashedPassword', function(err, user) { // don't ever give out the password or salt
    done(err, user);
  });
});

// add other strategies for more authentication flexibility
passport.use(new LocalStrategy({
    usernameField: 'email',
    passwordField: 'password' // this is the virtual field on the model
  },
  function(email, password, done) {
    User.findOne({
      email: email
    }, function(err, user) {
      if (err) return done(err);
      var errors = {};

      if (!user) {
        errors.knownEmail = true;
        errors.invalidPassword = true;
        errors.show = true;
      }
      if (user && !user.authenticate(password)) {
        errors.invalidPassword = true;
        errors.show = true;
      }
      if (errors.show) {
        return done(null, false, errors);
      };
      return done(null, user);
    });
  }
));

module.exports = passport;