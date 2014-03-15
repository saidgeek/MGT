'use strict';

var should = require('should'),
    mongoose = require('mongoose'),
    User = mongoose.model('User'),
    Category = mongoose.model('Category');

var category, user;

describe('Category Model', function(){

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

    category = new Category({
      name: 'category 1',
      description: 'category test',
      createdBy: user._id
    });

    Category.remove().exec();
    done();
  });

  afterEach(function(done){
    Category.remove().exec();
    done();
  });

  it('should bigin with no categories', function(done){
    Category.find({}, function(err, categories){
      should.not.exist(err);
      categories.should.have.length(0);
      done();
    });
  });

  it('should create category', function(done){
    category.save(function(err){
      should.not.exist(err);
      done();
    });
  });

  it('should update name category', function(done){
    category.save(function(err){
      var oldName = category.name;
      Category.findByIdAndUpdate(category._id, {name: 'category 2'}, function(err, c){
        should.not.exist(err);
        c.name.should.not.eql(oldName);
        done();
      });
    });
  });

  it('should update description category', function(done){
    category.save(function(err){
      var oldDescription = category.description;
      Category.findByIdAndUpdate(category._id, {description: 'category 2'}, function(err, c){
        should.not.exist(err);
        c.description.should.not.eql(oldDescription);
        done();
      });
    });
  });

  it('should find categories', function(done){
    category.save(function(err){
      Category.find({}, function(err, categories){
        should.not.exist(err);
        categories.should.have.length(1);
        done();
      });
    });
  });

  it('should find one categories with id', function(done){
    category.save(function(err){
      Category.findById(category._id, function(err, category){
        should.not.exist(err);
        should.exist(category);
        done();
      });
    });
  });

});