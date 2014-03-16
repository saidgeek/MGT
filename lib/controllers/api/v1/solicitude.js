'use strict';

var mongoose = require('mongoose'),
    Solicitude = mongoose.model('Solicitude');

exports.list = function(req, res) {
  Solicitude.find({}, function(err, solicitudes){
    if (err) return res.json(400, err);
    if (!solicitudes) return res.json(404);
    return res.json(200, solicitudes);
  });
};

exports.create = function(req, res) {
  if (!req.body.solicitude) return res.json(403);
  var solicitude = new Solicitude(req.body.solicitude);
  solicitude.createdBy = req.user ? req.user.userInfo.id : null
  solicitude.save(function(err){
    if (err) return res.json(400, err);
    return res.json(200, solicitude);
  });
};

exports.show = function(req, res){
  Solicitude.findById(req.params.id, function(err, solicitude){
    if (err) return res.json(400, err);
    if (!solicitude) return res.json(404);
    return res.json(200, solicitude);
  });
};

exports.update = function(req, res){
  if (!req.body.solicitude) return res.json(403);
  Solicitude.findByIdAndUpdate(req.params.id, req.body.solicitude, function(err, solicitude){
    if (err) return res.json(400, err);
    if (!solicitude) return res.json(404);
    return res.json(200, solicitude);
  });
};

exports.addTasks = function(req, res){
  if (!req.body.task) return res.json(403);
  Solicitude.findById(req.params.id, function(err, solicitude){
    if (err) return res.json(400, err);
    if (!solicitude) return res.json(404);
    var tasks = solicitude.tasks;
    tasks.push(req.body.task);
    solicitude.tasks = tasks;
    solicitude.save(function(err){
      if (err) return res.json(400, err);
      return res.json(200, solicitude);
    });
  });
};

exports.addComments = function(req, res){
  if (!req.body.comment) return res.json(403);
  Solicitude.findById(req.params.id, function(err, solicitude){
    if (err) return res.json(400, err);
    if (!solicitude) return res.json(404);
    var comments = solicitude.comments;
    comments.push(req.body.task);
    solicitude.comments = comments;
    solicitude.save(function(err){
      if (err) return res.json(400, err);
      return res.json(200, solicitude);
    });
  });
};

exports.changeState = function(req, res){
  if (!req.body.state) return res.json(403);
  Solicitude.findById(req.params.id, function(err, solicitude){
    if (err) return res.json(400, err);
    if (!solicitude) return res.json(404);
    solicitude.changeToState('queue_allocation', function(err, s){
      if (err) return res.json(400, err);
      if (!solicitude) return res.json(404);
      return res.json(200, s);
    });
  });
};