'use strict';

var mongoose = require('mongoose'),
    Solicitude = mongoose.model('Solicitude');

module.exports = function(jobs) {

  var SLAProccess = function(job, done) {

    var timeYellow = job.data.duration / 2;

    var yellowSLA = jobs.create('ChangeSLA', {
      solicitudeId: job.data.solicitudeId,
      type: 'YELLOW'
    })
    .delay(timeYellow)
    .priority('high')
    .save(function() {
      Solicitude.findById(job.data.solicitudeId, function(err, solicitude) {
        if (!err) {
          solicitude.action = 'jobs';
          solicitude.slaYellowId = yellowSLA.id;
          solicitude.save()
        };
      });
    });

    var redSLA = jobs.create('ChangeSLA', {
      solicitudeId: job.data.solicitudeId,
      type: 'RED'
    })
    .delay(job.data.duration)
    .priority('high')
    .save(function() {
      Solicitude.findById(job.data.solicitudeId, function(err, solicitude) {
        if (!err) {
          solicitude.action = 'jobs';
          solicitude.slaRedId = redSLA.id;
          solicitude.save()
        };
      });
    });

    done();
  };

  var SLAChangeProccess = function(job, done){

    Solicitude.findById(job.data.solicitudeId, function(err, solicitude) {
      if (!err) {
        solicitude.action = 'jobs';

        solicitude.sla = job.data.type;
        solicitude.save(function(err) {
          if (!err) {
            jobs.create('CreateLog', {
              user: solicitude.updatedBy,
              action: 'sla.change.to.'+job.data.type,
              _class: 'Solicitude',
              _classId: job.data.solicitudeId
            })
            .priority('high')
            .save();

            global.io.sockets.in('solicitude/change/sla').emit('solicitude.change.sla', {
              id: job.data.solicitudeId,
              state: job.data.type
            });
          };
        });
      };
    });

    done();
  };

  var SLARemoveProccess = function(job, done) {

    Solicitude.findById(job.data.solicitudeId, function(err, solicitude) {
      if (!err) {
        
        solicitude.action = 'jobs';
        solicitude.sla = null;

        var yellowKey = "q:job:"+solicitude.slaYellowId;
        var redKey = "q:job:"+solicitude.slaRedId;

        global.clientRedis.del([yellowKey, redKey], function(err, data) {
          if (!err) {
            solicitude.slaYellowId = null;
            solicitude.slaRedId = null;
            solicitude.save(function(err) {
              if (!err) {
                global.io.sockets.in('solicitude/remove/sla').emit('solicitude.remove.sla', {
                  id: job.data.solicitudeId
                });
              };
            });
          };
        });

      };
    });

    done();
  };

  jobs.process('CreateSLA', 50, SLAProccess);
  jobs.process('ChangeSLA', 50, SLAChangeProccess);
  jobs.process('RemoveSLA', 50, SLARemoveProccess);
};
