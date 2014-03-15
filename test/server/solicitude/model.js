'use strict';

var should = require('should'),
    mongoose = require('mongoose'),
    Solicitude = mongoose.model('Solicitude'),
    User = mongoose.model('User'),
    Token = mongoose.model('Token');

var solicitude, user, _tasks, _comments, _involved;

describe('Solicitude Model', function(){

  beforeEach(function(done){
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
      {descrioption: 'task 1'},
      {descrioption: 'task 2'}
    ];
    _comments = [
      {content: 'comment 1', involved: _involved},
      {content: 'comment 2', involved: _involved}
    ];

    solicitude = new Solicitude({
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
    });

    Solicitude.remove().exec();
    done();
  });

  afterEach(function(done){
    Solicitude.remove().exec();
    done();
  });


  it('should begin with no solicitude', function(done){
    Solicitude.find({}, function(err, solicitudes){
      should.not.exist(err);
      solicitudes.should.have.length(0);
      done();
    });
  });

  it('should save new solicitude', function(done){
    solicitude.save(function(err){
      should.not.exist(err);
      done();
    });
  });

  it('should add tasks in solicitude', function(done) {
    solicitude.save(function(err){
      Solicitude.findByIdAndUpdate(solicitude._id, {tasks: _tasks}, function(err, solicitude){
        solicitude.tasks.should.have.length(2);
        done();
      });
    });
  });

  it('should add comments in solicitude', function(done) {
    solicitude.save(function(err){
      Solicitude.findByIdAndUpdate(solicitude._id, {comments: _comments}, function(err, solicitude){
        solicitude.comments.should.have.length(2);
        solicitude.comments[0].involved.should.have.length(1);
        solicitude.comments[1].involved.should.have.length(1);
        done();
      });
    });
  });

  it('should change to new state', function(done){
    solicitude.save(function(err){
      Solicitude.findById(solicitude._id, function(err, solicitude){
        var oldState = solicitude.state;
        solicitude.changeToState('queue_allocation', function(err, s){
          should.not.exist(err);
          s.state.should.not.eql(oldState);
          done();
        });
      });
    });
  });

  it('should change to new state invalid', function(done){
    solicitude.save(function(err){
      Solicitude.findById(solicitude._id, function(err, solicitude){
        var oldState = solicitude.state;
        solicitude.changeToState('queue_validation', function(err, s){
          should.exist(err);
          done();
        });
      });
    });
  });

  it('should find solicitude', function(done){
    solicitude.save(function(err){
      Solicitude.find({}, function(err, solicitudes){
        should.not.exist(err);
        solicitudes.should.have.length(1);
        done();
      });
    });
  });

  it('should find one solicitude with id', function(done){
    solicitude.save(function(err){
      Solicitude.findById(solicitude._id, function(err, solicitude){
        should.not.exist(err);
        should.exist(solicitude);
        done();
      });
    });
  });

});