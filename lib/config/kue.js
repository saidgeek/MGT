'use strict';

var fs = require('fs'),
    path = require('path'),
    config = require('./config'),
    kue = require('kue'),
    jobs = kue.createQueue({
      redis: {
        port: config.redis.port,
        host: config.redis.host,
        auth: config.redis.auth
      },
      disableSearch: true
    });

module.exports = function(app) {


  var jobsPath = path.join(__dirname, '../jobs');
  fs.readdirSync(jobsPath).forEach(function (file) {
    if (/(.*)\.(js$|coffee$)/.test(file)) {
      require(jobsPath + '/' + file)(jobs);
    }
  });

  kue.app.listen(3001);
  console.log('kue server monitor satret port 3001');

  jobs.promote();

  jobs.on('complete', function(result){
    console.log("Job completed with data ", result);
  }).on('failed', function(){
    console.log("Job failed");
  }).on('progress', function(progress){
    process.stdout.write('\r  job #' + job.id + ' ' + progress + '% complete');
  }).on('promote', function(promote){
    process.stdout.write(promote);
  });

  global.kue = kue;
  global.jobs = jobs;

}