'use strict';

module.exports = {
  env: 'development',
  mongo: {
    uri: 'mongodb://localhost/movistar-dev'
  },
  redis: {
    port: 6379,
    host: '127.0.0.1',
    auth: ''
  }
};