'use strict';

module.exports = {
  env: 'test',
  mongo: {
    uri: 'mongodb://localhost/movistar-test'
  },
  redis: {
    port: 6379,
    host: '127.0.0.1',
    auth: ''
  },
  mandrill: '9cyYwqPH5H0YbKF1zjUvpg',
  filepicker: {
    key: 'ALYbjhKLjSKiT6sNRHw4Yz'
  },
  dummyDataPro: process.env.DUMMY_DATA || false
};
