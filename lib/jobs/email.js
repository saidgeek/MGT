'use strict';

var mongoose = require('mongoose'),
    Email = mongoose.model('Email'),
    makeEmail = require('../makeEmail');

module.exports = function(jobs) {

  var EmailProcess = function(job, done){
    Email.findById(job.data.id, function(err, email) {
      if (err) return err;
      var email = new makeEmail({
        html: email.html,
        text: email.text,
        subject: email.subject,
        to: email.to
      });
      email.send();
    });
    done();
  }

  jobs.process('sendEmail', 50, EmailProcess);

};