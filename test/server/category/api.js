'use strict';

var should = require('should'),
    app = require('../../../server'),
    request = require('supertest'),
    mongoose = require('mongoose'),
    User = mongoose.model('User'),
    Category = mongoose.model('Category'),
    Token = mongoose.model('Token');

var category, token, user;

describe('GET /api/v1/categories', function() {

  beforeEach(function(done){
    token = new Token({
      description: 'test token',
      token: true
    });

    user = new User({
      provider: 'local',
      profile: {
        firstName: 'Fake',
        lastName: 'user',
        description: 'The tests user',
        phoneNumber: '000000000'
      },
      email: 'test@test.com',
      password: 'password'
    });

    category = {
      name: 'category 1',
      description: 'category test',
      createdBy: user._id
    };

    token.save(function(err){
      done();
    });
  });

  afterEach(function(done){
    Token.remove().exec();
    Category.remove().exec();
    done();
  });
  
  it('should respond with JSON array list', function(done) {
    var _category = new Category(category);
    _category.save(function(err){
      request(app)
        .get('/api/v1/categories')
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
  });

  it('should create category',  function(done){
    request(app)
      .post('/api/v1/category')
      .expect(200)
      .expect('Content-Type', /json/)
      .send({
        clientToken: token.clientToken,
        accessToken: token.accessToken,
        category: {
          name: 'category 1',
          description: 'category test',
          createdBy: user._id
        }
      })
      .end(function(err, res) {
        if (err) return done(err);
        res.status.should.eql(200);
        should.exist(res.body);
        done();
    });
  });

  it('should show category', function(done){
    var _category = new Category(category);
    _category.save(function(err){
      request(app)
        .get('/api/v1/category/'+_category._id)
        .expect(200)
        .expect('Content-Type', /json/)
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
  
  it('should update category',  function(done){
    var _category = new Category(category);
    _category.save(function(err){
      request(app)
        .put('/api/v1/category/'+_category._id)
        .expect(200)
        .expect('Content-Type', /json/)
        .send({
          clientToken: token.clientToken,
          accessToken: token.accessToken,
          category: {
            name: 'category 2',
            description: 'category test 2',
          }
        })
        .end(function(err, res) {
          if (err) return done(err);
          res.status.should.eql(200);
          res.body.name.should.eql('category 2');
          res.body.description.should.eql('category test 2');
          done();
      });
    });
  });

});