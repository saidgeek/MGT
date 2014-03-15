'use strict';

var should = require('should'),
    mongoose = require('mongoose'),
    User = mongoose.model('User'),
    Solicitude = mongoose.model('Solicitude'),
    Notification = mongoose.model('Notification');

var notification, user, solicitude;

describe('Notification Model', function(){

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

    solicitude = new Solicitude({
      priority: 'SMALL',
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

    notification = new Notification({
      to: [{user: user._id,}],
      description: 'New notification',
      solicitude: solicitude._id
    });

    Notification.remove().exec();
    done();
  });

  afterEach(function(done){
    Notification.remove().exec();
    done();
  });

  it('should begin with no notifications', function(done){
    Notification.find({}, function(err, notifications){
      should.not.exist(err);
      notifications.should.have.length(0);
      done();
    });
  });

  it('should create notification', function(done){
    notification.save(function(err){
      should.not.exist(err);
      done();
    });
  });

  it('should change to read by user', function(done){
    notification.save(function(err){
      Notification.findById(notification._id, function(err, notify){
        notify.readed(user._id, function(err, n){
          should.not.exist(err);
          n.readByUser(user._id).should.be.true;
          done();
        });
      });
    });
  });

  it('should find notifications', function(done){
    notification.save(function(err){
      Notification.find({}, function(err, notifications){
        should.not.exist(err);
        notifications.should.have.length(1);
        done();
      });
    });
  });

  it('should find one notifications with id', function(done){
    notification.save(function(err){
      Notification.findById(notification._id, function(err, notification){
        should.not.exist(err);
        should.exist(notification);
        done();
      });
    });
  });

  it('should find notifications with user_id', function(done){
    notification.save(function(err){
      Notification.find({'to.user': user._id}, function(err, notifications){
        should.not.exist(err);
        notifications.should.have.length(1);
        done();
      });
    });
  });

  it('should find notifications with user_id fake', function(done){
    notification.save(function(err){
      Notification.find({'to.user': 'bbbbhv'}, function(err, notifications){
        should.exist(err);
        done();
      });
    });
  });

});