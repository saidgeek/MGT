'use strict';

var should = require('should'),
    app = require('../../../server'),
    request = require('supertest'),
    mongoose = require('mongoose'),
    User = mongoose.model('User'),
    Solicitude = mongoose.model('Solicitude'),
    Token = mongoose.model('Token');

var solicitude, user, token, _involved, _tasks, _comments;

describe('GET /api/v1/solicitude', function() {

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

    _involved = [{user: user._id}];

    _tasks = [
      {description: 'task 1'},
      {description: 'task 2'}
    ];

    _comments = [
      {content: 'comment 1', involved: _involved},
      {content: 'comment 2', involved: _involved}
    ];

    solicitude = {
      priority: 'SMALL',
      involved: _involved,
      ticket:{
        title: 'test',
        description: 'descripcion del ticket de test',
        segments: [
          'segment 1',
          'segment 2'
        ],
        sections: [
          'section 1',
          'section 2'
        ],
        startedAt: Date.now(),
        endedAt: Date.now(),
        createdBy: user._id
      }
    };

    token.save(function(err){
      done();
    });
  });

  afterEach(function(done){
    Token.remove().exec();
    Solicitude.remove().exec();
    done();
  });
  
  it('should respond with JSON array list', function(done) {
    var _solicitude = new Solicitude(solicitude);
    _solicitude.save(function(err){
      request(app)
        .get('/api/v1/solicitudes')
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

  it('should create solicitude', function(done){
    request(app)
      .post('/api/v1/solicitude')
      .expect(200)
      .expect('Content-Type', /json/)
      .send({
        clientToken: token.clientToken,
        accessToken: token.accessToken,
        solicitude: solicitude
      })
      .end(function(err, res) {
        if (err) return done(err);
        res.status.should.eql(200);
        should.exist(res.body);
        done();
    });
  });
  
  it('should show solicitude', function(done){
    var _solicitude = new Solicitude(solicitude);
    _solicitude.save(function(err){
      request(app)
        .get('/api/v1/solicitude/'+_solicitude._id)
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

  it('should update solicitude', function(done){
    var _involved = [{user: user._id}, {user: user._id}];
    var _solicitude = new Solicitude(solicitude);
    _solicitude.save(function(err){
      request(app)
        .put('/api/v1/solicitude/'+_solicitude._id)
        .expect(200)
        .expect('Content-Type', /json/)
        .send({
          clientToken: token.clientToken,
          accessToken: token.accessToken,
          solicitude: {
            priority: 'MEDIUM',
            involved: _involved,
            ticket:{
              title: 'test 1',
              description: 'descripcion del ticket de test 1',
              segments: [
                'segment 1',
                'segment 2',
                'segment 3'
              ],
              sections: [
                'section 1',
                'section 2',
                'section 3'
              ]
            }
          }
        })
        .end(function(err, res) {
          if (err) return done(err);
          res.status.should.eql(200);
          res.body.priority.should.eql('MEDIUM');
          res.body.involved.should.have.length(2);
          res.body.ticket.title.should.eql('test 1');
          res.body.ticket.description.should.eql('descripcion del ticket de test 1');
          res.body.ticket.segments.should.have.length(3);
          res.body.ticket.sections.should.have.length(3);
          done();
      });
    });
  });

  it('should added tasks to solicitude', function(done){
    var _solicitude = new Solicitude(solicitude);
    _solicitude.tasks = _tasks;
    _solicitude.save(function(err){
      request(app)
        .put('/api/v1/solicitude/'+_solicitude._id+'/add/tasks')
        .expect(200)
        .expect('Content-Type', /json/)
        .send({
          clientToken: token.clientToken,
          accessToken: token.accessToken,
          task: {description: 'task 3'}
        })
        .end(function(err, res) {
          if (err) return done(err);
          res.status.should.eql(200);
          res.body.tasks.should.have.length(3);
          done();
      });
    });
  });
  
  it('should added comments to solicitude', function(done){
    var _solicitude = new Solicitude(solicitude);
    _solicitude.comments = _comments;
    _solicitude.save(function(err){
      request(app)
        .put('/api/v1/solicitude/'+_solicitude._id+'/add/comments')
        .expect(200)
        .expect('Content-Type', /json/)
        .send({
          clientToken: token.clientToken,
          accessToken: token.accessToken,
          comment: {content: 'comment 3', involved: _involved}
        })
        .end(function(err, res) {
          if (err) return done(err);
          res.status.should.eql(200);
          res.body.comments.should.have.length(3);
          done();
      });
    });
  });
  
  it('should change state to solicitude', function(done){
    var _solicitude = new Solicitude(solicitude);
    _solicitude.save(function(err){
      request(app)
        .put('/api/v1/solicitude/'+_solicitude._id+'/change/state')
        .expect(200)
        .expect('Content-Type', /json/)
        .send({
          clientToken: token.clientToken,
          accessToken: token.accessToken,
          state: 'queue_allocation'
        })
        .end(function(err, res) {
          if (err) return done(err);
          res.status.should.eql(200);
          res.body.state.should.not.eql('QUEUE_VALIDATION');
          res.body.state.should.eql('QUEUE_ALLOCATION');
          done();
      });
    });
  });

});