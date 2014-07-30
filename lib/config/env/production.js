'use strict';

module.exports = {
  env: 'production',
  mongo: {
    uri: process.env.MONGOLAB_URI ||
         process.env.MONGOHQ_URL ||
         'mongodb://localhost/movistar'
  },
  redis: {
    port: process.env.REDIS_PORT,
    host: process.env.REDIS_HOST,
    auth: process.env.REDIS_AUTH
  },
  mandrill: process.env.MANDRILL_KEY,
  filepicker: {
    key: 'Aa1n8PVeeSuSHAc6cX4JUz'
  },
  dummyDataPro: process.env.DUMMY_DATA || false,
  sendEmails: process.env.SEND_EMAIL || true
};
