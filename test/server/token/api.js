'use strict';

var should = require('should'),
    app = require('../../../server'),
    request = require('supertest');

// describe('GET /api/v1/users/me', function() {
  
//   it('should respond with JSON array', function(done) {
//     request(app)
//       .get('/api/v1/users/me')
//       .expect(200)
//       .expect('Content-Type', /json/)
//       .end(function(err, res) {
//         if (err) return done(err);
//         res.body.should.be.instanceof(Array);
//         done();
//       });
//   });
// });