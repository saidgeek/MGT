'use strict';

var should = require('should'),
    mongoose = require('mongoose'),
    User = mongoose.model('User'),
    Report = mongoose.model('Report');

var report, user;

describe('Report Model', function(){

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

    report = new Report({
      user: user._id,
      _typeId: user._id,
      _type: User.modelName,
      action: 'CREATE',
      description: 'User create'
    });

    Report.remove().exec();
    done();
  });

  afterEach(function(done){
    Report.remove().exec();
    done();
  });

  it('should begin with no report', function(done){
    Report.find({}, function(err, reports){
      should.not.exist(err);
      reports.should.have.length(0);
      done();
    });
  });

  it('should create report', function(done){
    report.save(function(err){
      should.not.exist(err);
      done();
    });
  });

  it('should find report with id', function(done){
    report.save(function(err){
      Report.findById(report._id, function(err, report){
        should.not.exist(err);
        should.exist(report);
        done();
      });
    });
  });

  it('should find reports', function(done){
    report.save(function(err){
      Report.find({}, function(err, reports){
        should.not.exist(err);
        reports.should.have.length(1);
        done();
      });
    });
  });

  it('should find report with user_id', function(done){
    report.save(function(err){
      Report.find({user: user._id}, function(err, reports){
        should.not.exist(err);
        reports.should.have.length(1);
        done();
      });
    });
  });


});