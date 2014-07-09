'use strict';

module.exports = function(io, server) {

  var _io = io.listen(server, { log: false });

  _io.configure(function () { 
    _io.set("transports", ["xhr-polling"]); 
    _io.set("polling duration", 10); 
  });

  _io.sockets.on('connection', function(sckt) {

    // GLOBALES
    sckt.on('register.solicitude.globals', function(data) {
      if (typeof(data) !== 'undefined' && typeof(data.id) !== 'undefined') {
        sckt.join('solicitude/new/'+data.id);
        sckt.join('notifications/'+data.id);
      };

      sckt.join('solicitude/filter/change');
      
      sckt.join('solicitude/init/sla');
      sckt.join('solicitude/change/sla');
      sckt.join('solicitude/remove/sla');

      sckt.join('solicitude/new/comment');
      sckt.join('task/new/comment');

    });

  });

  global.io = _io;

};