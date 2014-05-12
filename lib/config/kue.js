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
    }),
    redis = require('redis'),
    clientRedis = redis.createClient(config.redis.port, config.redis.host, {
      auth_pass: config.redis.auth
    });

module.exports = function(app) {

  jobs.promote();

  var jobsPath = path.join(__dirname, '../jobs');
  fs.readdirSync(jobsPath).forEach(function (file) {
    if (/(.*)\.(js$|coffee$)/.test(file)) {
      require(jobsPath + '/' + file)(jobs);
    }
  });

  if (app.get('env') === 'development') {
    kue.app.listen(3001);
    console.log('kue server monitor satret port 3001');
    // jobs.create('test', { name: 'test', status: 'ok' }).delay((60000/2)).priority('high').save();
  };

  global.jobs = jobs;

  clientRedis.on("connect", function (err) {
    console.log("Connect to redis ");
  });

  clientRedis.on("error", function (err) {
    console.log("Error redis " + err);
  });

  global.clientRedis = clientRedis;

}