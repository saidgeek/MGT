'use strict';

var mongoose = require('mongoose'),
    Log = mongoose.model('Log');

module.exports = function(jobs) {

  var LogProcess = function(job, done){

    var log = new Log();

    log.user = job.data.user;
    log._classId = job.data._classId;
    log._class = job.data._class;
    log.action = job.data.action;


    log.save(function (err) {
      if (!err) {
        // aqui se podria lanzar un socket.io, cuando hayan graficos o alguna pantalla con el log
      }
    });

    done();
  }

  jobs.process('CreateLog', 50, LogProcess);

};
