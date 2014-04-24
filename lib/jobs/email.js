'use strict';

var mongoose = require('mongoose'),
    Email = mongoose.model('Email');

module.exports = function(jobs) {

  var EmailProcess = function(job, done){

    var email = new Email(job.data);
    email.save();
    done();
  }

  jobs.process('sendEmail', 50, EmailProcess);

};
