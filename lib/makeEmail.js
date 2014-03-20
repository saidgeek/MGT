'use strict';

module.exports = function(data){

  var html = data.html,
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

    var sending = function() {
      var message = makeMessage();
      global.mandrill.messages.send({message: message, async: true}, function(result) {
        console.log(result);
      }, function(e) {
        console.log('A mandrill error occurred: ' + e.name + ' - ' + e.message);
      });
    };

    return {
      send: function(cb) {
        sending();
      }
    };
  };

  return init();
};

