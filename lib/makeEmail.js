'use strict';


module.exports = function(data){
  var mongoose = require('mongoose'),
      Email = mongoose.model('Email');

  var id = data.id,
      html = data.html,
      text = data.text || '',
      subject = data.subject,
      to = data.to;

  function init () {

    var makeMessage = function () {
      return {
        html: html,
        text: text,
        subject: subject,
        from_email: "support@movistar.cl",
        from_name: "Gestor de tareas movistar",
        to: to,
        // headers: {
        //     'Reply-To': "message.reply@example.com"
        // },
        important: false,
        inline_css: null,
      };
    };

    var _sendingState = function (type, desc) {
      console.log('id:', id);
      Email.findById(id, function (err, email) {
        if (!err) {
          email.state = type;
          email.errDesc = desc ? desc : null;
          email.save();
        }
      });
    };

    var sending = function() {
      var message = makeMessage();
      global.mandrill.messages.send({message: message, async: true}, function(result) {
        console.log(result);
        _sendingState('SENDED', null);
      }, function(e) {
        console.log('A mandrill error occurred: ' + e.name + ' - ' + e.message);
        _sendingState('ERROR', 'A mandrill error occurred: ' + e.name + ' - ' + e.message);
      });
    };

    return {
      send: function(cb) {
        sending(cb);
      }
    };
  };

  return init();
};
