'use strict';

var mongoose = require('mongoose'),
    Notification = mongoose.model('Notification');

module.exports = function(jobs) {

  var NotificationProcess = function(job, done){

    var notify = new Notification();

    notify.to = job.data.to;
    notify.from = job.data.from;
    notify._type = job.data._type;
    notify._class = job.data._class;
    notify._classId = job.data._classId;

    notify.save(function (err) {
      if (!err) {
        // lanzar socket.io
        global.io.sockets.in('notifications/'+job.data.to).emit('reload.notifications', {});
      }
    });

    done();
  }

  jobs.process('CreateNotification', 50, NotificationProcess);

};
