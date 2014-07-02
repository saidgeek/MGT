'use strict';

var mongoose = require('mongoose'),
    Email = mongoose.model('Email'),
    config = require('../config/config');

module.exports = function(jobs) {

  var EmailProcess = function(job, done){

    if (config.sendEmails === true || config.sendEmails == 'true') {
      var email = new Email(job.data);
      email.save();
      done();
    } else {
      console.log('suprimido el envio de correos');
    };
  }

  jobs.process('sendEmail', 50, EmailProcess);

};
