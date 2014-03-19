'use strict';

module.exports = function(jobs) {

  var TestProcess = function(job, done){
    console.log('start');
    setTimeout(function () {
        console.log('jobs process: --->', job.data);
        done();
    }, 60000);
  }

  jobs.process('test', TestProcess);

};