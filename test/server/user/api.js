'use strict';

var should = require('should'),
    app = require('../../../server'),
    request = require('supertest'),
    mongoose = require('mongoose'),
    Token = mongoose.model('Token'),
    User = mongoose.model('User');

var token, user;

describe('GET /api/v1/users', function() {

  beforeEach(function(done){
    token = new Token({
      description: 'test token',
      token: true
    });

    user = {
      profile: {
        firstName: 'Fake',
        lastName: 'user',
        description: 'The tests user',
        phoneNumber: '000000000'
      },
      email: 'test@test.com'
    };

    token.save(function(err){
      done();
    });
  });

  afterEach(function(done){
    Token.remove().exec();
    User.remove().exec();
    done();
  });
  
  it('should respond with JSON array list', function(done) {
    request(app)
      .get('/api/v1/users')
      .expect(200)
      .expect('Content-Type', /json/)
      .send({
        clientToken: token.clientToken,
        accessToken: token.accessToken
      })
      .end(function(err, res) {
        if (err) return done(err);
        res.body.should.be.instanceof(Array);
        (res.body.length).should.be.within(1, 1);
        done();
      });
  });

  it('should create user', function(done){
    request(app)
      .post('/api/v1/user')
      .expect('Content-Type', /json/)
      .expect(200)
      .send({
        clientToken: token.clientToken,
        accessToken: token.accessToken,
        user: user
      })
      .end(function(err, res) {
        if (err) return done(err);
        res.status.should.eql(200);
        should.exist(res.body);
        done();
      });
  });

  it('should show user with id', function(done){
    var _user = new User(user);
    _user.save(function(err){
      request(app)
        .get('/api/v1/user/'+_user._id)
        .expect('Content-Type', /json/)
        .expect(200)
        .send({
          clientToken: token.clientToken,
          accessToken: token.accessToken
        })
        .end(function(err, res) {
          if (err) return done(err);
          res.status.should.eql(200);
          should.exist(res.body);
          done();
        });
    });
  });

  it('should update user and return user upgrate', function(done){
    var _user = new User(user);
    _user.save(function(err){
      request(app)
        .put('/api/v1/user/'+_user._id+'/update/profile')
        .expect('Content-Type', /json/)
        .expect(200)
        .send({
          clientToken: token.clientToken,
          accessToken: token.accessToken,
          profile: {
            firstName: 'Fake 1',
            lastName: 'user 1',
            description: 'The tests user 1',
            phoneNumber: '000000001'
          }
        })
        .end(function(err, res) {
          if (err) return done(err);
          res.status.should.eql(200);
          res.body.profile.firstName.should.eql('Fake 1');
          res.body.profile.lastName.should.eql('user 1');
          res.body.profile.description.should.eql('The tests user 1');
          res.body.profile.phoneNumber.should.eql('000000001');
          done();
        });
    });
  });

  it('should create password', function(done){
    var _user = new User(user);
    _user.save(function(err){
      request(app)
        .post('/api/v1/user/confirm/'+_user.confirmToken)
        .expect('Content-Type', /json/)
        .expect(200)
        .send({
          confirmPassword: '123456',
          password: '123456'
        })
        .end(function(err, res) {
          if (err) return done(err);
          res.status.should.eql(200);
          done();
        });
    });
  });
  
  it('should change password', function(done){
    user.password = '123456';
    var _user = new User(user);
    _user.save(function(err){
      request(app)
        .put('/api/v1/user/'+_user._id+'/change/password')
        .expect('Content-Type', /json/)
        .expect(200)
        .send({
          clientToken: token.clientToken,
          accessToken: token.accessToken,
          oldPassword: '123456',
          newPassword: '654321'
        })
        .end(function(err, res) {
          if (err) return done(err);
          res.status.should.eql(200);
          done();
        });
    });
  });
  
  it('should delete user', function(done){
    var _user = new User(user);
    _user.save(function(err){
      request(app)
        .del('/api/v1/user/'+_user._id)
        .expect('Content-Type', /json/)
        .expect(200)
        .send({
          clientToken: token.clientToken,
          accessToken: token.accessToken
        })
        .end(function(err, res) {
          if (err) return done(err);
          res.status.should.eql(200);
          done();
        });
    });
  });

  it('should recovery password of user', function(done){
    var _user = new User(user);
    _user.save(function(err){
      request(app)
        .put('/api/v1/user/recovery')
        .expect('Content-Type', /json/)
        .expect(200)
        .send({
          clientToken: token.clientToken,
          accessToken: token.accessToken,
          email: user.email
        })
        .end(function(err, res) {
          if (err) return done(err);
          res.status.should.eql(200);
          done();
        });
    });
  });

});