'use strict';

var mongoose = require('mongoose'),
    Notification = mongoose.model('Notification');

module.exports = function(jobs) {

  var NotificationProcess = function(job, done){

    var notify = new Notification();
    notify.to = job.data.to;
    notify.from = job.data.from;
    notify.message = job.data.message;
    notify._class = job.data._class;
    notify._classId = job.data._classId;
    notify.save();

    done();
  }

  jobs.process('CreateNotification', 10, NotificationProcess);

};
