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
  },
  mandrill: 'iLf9KcxOpIfJyDijczbU3w',
  filepicker: {
    key: 'Aa1n8PVeeSuSHAc6cX4JUz'
  },
  dummyDataPro: process.env.DUMMY_DATA || false,
  sendEmails: true
};
