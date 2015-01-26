'use strict';

var mongoose = require('mongoose'),
    Email = mongoose.model('Email'),
    Solicitude = mongoose.model('Solicitude'),
    config = require('../config/config');

module.exports = function(jobs) {


  var SolicitudeEmail = function(job, done) {

    if (config.sendEmails === true || config.sendEmails == 'true') {

      var _to, _cc, _solicitude_id, _subject, _content, data_email = {};

      console.log('jpb.data:', job.data);

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

            console.log('solicitude:', solicitude);

            var cc = [];

            var email = new Email();

            email.to = solicitude[_to].profile.firstName+' '+solicitude[_to].profile.lastName+' <'+solicitude[_to].email+'>';

            _content.data['to'] = solicitude[_to].profile.firstName+' '+solicitude[_to].profile.lastName;

            if (_cc !== null) {
              for (var i = 0; i < _cc.length; i++) {
                var this_cc = _cc[i];
                cc.push(solicitude[this_cc].profile.firstName+' '+solicitude[this_cc].profile.lastName+' <'+solicitude[this_cc].email+'>');
              };
            };

            email.cc = cc.join(', ');

            email.subject = _subject;
            email.content = _content;

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
      var email = new Email();

      email.to = job.data.to[0].name+' <'+job.data.to[0].email+'>'
      email.subject = job.data.subject;
      email.content = job.data.content;

      email.save();
      done();
    } else {
      console.log('suprimido el envio de correos');
    };
  }

  jobs.process('sendEmail', 50, EmailProcess);
  jobs.process('sendSolicitudeEmail', 50, SolicitudeEmail);

};
