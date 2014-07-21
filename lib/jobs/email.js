'use strict';

var mongoose = require('mongoose'),
    Email = mongoose.model('Email'),
    Solicitude = mongoose.model('Solicitude'),
    config = require('../config/config');

module.exports = function(jobs) {


  var SolicitudeEmail = function(job, done) {

    if (config.sendEmails === true || config.sendEmails == 'true') {

      var _to, _cc, _solicitude_id, _subject, _content, data_email = {};

      _to = job.data.to;
      _cc = job.data.cc || null; // []
      _solicitude_id = job.data.solicitude_id;
      _subject = job.data.subject;
      _content = job.data.content;

      Solicitude.findById(_solicitude_id)
        .populate('editor')
        .populate('applicant')
        .populate('responsible')
        .populate('provider')
        .exec(function(err, solicitude) {
          if (!err) {

            var to = [];

            to.push({ 
              email: solicitude[_to].email, 
              name: solicitude[_to].profile.firstName+' '+solicitude[_to].profile.lastName,
              type: 'to'
            });

            if (_cc !== null) {
              for (var i = 0; i < _cc.length; i++) {
                var cc = _cc[i];
                to.push({
                  email: solicitude[cc].email,
                  name: solicitude[cc].profile.firstName+' '+solicitude[cc].profile.lastName,
                  type: 'cc'
                });
              };
            };


            data_email = {
              to: to,
              subject: _subject,
              content: _content
            };

            var email = new Email(data_email);
            email.save();
            done();

          };
        });
      
    } else {
      console.log('suprimido el envio de correos de solicitudes');
    };

  };

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
  jobs.process('sendSolicitudeEmail', 50, SolicitudeEmail);

};
