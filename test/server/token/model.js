'use strict';

var should = require('should'),
    mongoose = require('mongoose'),
    Token = mongoose.model('Token');

var token;

describe('Token Model', function(){
  
  beforeEach(function(done){
    token = new Token({
      description: 'test token',
      token: true
    });
    Token.remove().exec();
    done();
  });

  afterEach(function(done){
    Token.remove().exec();
    done();
  });

  it('should begin with no tokens', function(done){
    Token.find({}, function(err, tokens){
      should.not.exist(err);
      tokens.should.have.length(0);
      done();
    });
  });

  it('should save new token', function(done){
    token.save(function(err){
      should.not.exist(err);
      done();
    });
  });

  it('should authenticate token is true', function(done){
    token.save(function(err){
      var tokens = token.info;
      token.authenticate(tokens).should.be.true;  
      done();
    });
    
  });

  it('should length is equal to 1', function(done){
    token.save(function(err){
      Token.find({}, function(err, tokens){
        should.not.exist(err);
        tokens.should.have.length(1);
        done();
      });
    });
  });

  it('should find by id with token id', function(done){
    token.save(function(err){
      Token.findById(token._id, function(err, _token){
        should.not.exist(err);
        _token.token.should.have.eql(token.token);
        done();
      });
    });
  });

  it('should find one token with clientToken and accessToken', function(done){
    token.save(function(err){
      Token.findOne({clientToken: token.clientToken, accessToken: token.accessToken}, function(err, _token){
        should.not.exist(err);
        _token.token.should.have.eql(token.token);
        done();
      });
    });
  });

  it('should delete token with token id', function(done){
    token.save(function(err){
      Token.findByIdAndRemove(token._id, function(err){
        should.not.exist(err);
        done();
      });
    });
  });  

});