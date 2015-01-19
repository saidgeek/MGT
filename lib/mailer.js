'use strict';

module.exports = function(email_id) {

  var mongoose = require('mongoose'),
    Email = mongoose.model('Email'),
    mailer = require('nodemailer');

  var _email_id = email_id;

  function init() {

    var mailer_options = function(data, cb) {

      var options = {

        from: 'Gestor tareas <gestormovistar@fusiona.cl>',
        to: data.to,
        subject: data.subject,
        text: data.text,
        html: data.html

      };

      if (typeof(data.cc) !== 'undefined' && data.cc !== null) {
        options['cc'] = data.cc;
      };

      return cb(options);
    };

    var sending = function() {

      console.log('email id:', _email_id);

      Email.findById(_email_id)
        .exec(function(err, email) {
          if (!err) {

            mailer_options(email, function(options) {

              var _smtpTransport = mailer.createTransport({
                service: 'gmail',
                auth: {
                  user: 'gestormovistar@fusiona.cl',
                  pass: 'osnrKY5UcR'
                }
              });

              _smtpTransport.sendMail(options, function(err, res) {
                if(err){
                  console.log(err);
                  email.state = 'error';
                }else{
                  console.log("Message sent: ", res);
                  email.state = 'sent';
                };

                email.save();
                _smtpTransport.close();
              });

            });

          };
        });

    };


    return {
      send: function() {
        sending();
      }
    };

  }

  return init();

};