'use strict';

var should = require('should'),
    mongoose = require('mongoose'),
    User = mongoose.model('User'),
    Token = mongoose.model('Token');

var user;

describe('User Model', function() {
  beforeEach(function(done) {
    var token = new Token({
      description: 'User access tokens',
      token: true
    });
    Token.remove().exec();
    token.save(function(err){
      user = new User({
        provider: 'local',
        profile: {
          firstName: 'Fake',
          lastName: 'user',
          description: 'The tests user',
          phoneNumber: '000000000'
        },
        access: token.info,
        email: 'test@test.com',
        password: 'password'
      });
    });

    // Clear users before testing
    User.remove().exec();
    done();
  });

  afterEach(function(done) {
    Token.remove().exec();
    User.remove().exec();
    done();
  });

  it('should begin with no users', function(done) {
    User.find({}, function(err, users) {
      users.should.have.length(0);
      done();
    });
  });

  it('should fail when saving a duplicate user', function(done) {
    user.save();
    var userDup = new User(user);
    userDup.save(function(err) {
      should.exist(err);
      done();
    });
  });

  it('should return tokens', function(done) {
    user.save();
    should.exist(user.access);
    should.exist(user.access.clientToken);
    should.exist(user.access.accessToken);
    done();
  });  

  it('should return user', function(done){
    user.save(function(err){
      User.findOne({email: user.email}, function(err, usr){
        should.not.exist(err);
        usr.email.should.have.eql(user.email);
        done();
      });
    });
  });

  it('should fail when saving without an email', function(done) {
    user.email = '';
    user.save(function(err) {
      should.exist(err);
      done();
    });
  });

  it("should authenticate user if password is valid", function() {
    user.authenticate('password').should.be.true;
  });

  it("should not authenticate user if password is invalid", function() {
    user.authenticate('blah').should.not.be.true;
  });

});