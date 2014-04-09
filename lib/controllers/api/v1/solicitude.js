'use strict';

var mongoose = require('mongoose'),
    Solicitude = mongoose.model('Solicitude'),
    User = mongoose.model('User');

exports.list = function(req, res) {
  var _state = [''];
  if (!(req.query.state instanceof Array)) {
    _state[0] = req.query.state.toString();
  } else {
    _state = req.query.state;
  };
  Solicitude.find({ state: { $in: _state } })
  .exec(function(err, solicitudes){
    if (err) return res.json(400, err);
    if (!solicitudes) return res.json(404);
    return res.json(200, solicitudes);
  });
};

exports.groups = function (req, res) {
  Solicitude.aggregate([{ $match: { state: { $in: req.query.states }  } }, { $group: { _id: '$state', count: { $sum: 1 } } }], function (err, groups) {
    if (err) return res.json(400, err);
    if (!groups) return res.json(404);
    return res.json(200, groups);
  });
}

exports.create = function(req, res) {
  if (!req.body.solicitude) return res.json(403);
  var solicitude = new Solicitude(req.body.solicitude);
  solicitude.createdBy = req.user ? req.user.userInfo.id : null
  var _involved = [];
  User.findById(solicitude.createdBy, function(err, user){
    if (err) return false;
    if (~['CLIENT', 'ADMIN', 'ROOT'].indexOf(user.role)) {
      _involved.push({
        user: user._id,
        role: user.role,
        isRead: false,
        readedAt: null
      });
      User.findOne({ role: 'EDITOR' }, function (err, user) {
        _involved.push({
          user: user._id,
          role: user.role,
          isRead: false,
          readedAt: null
        });
        solicitude.involved = _involved;
        solicitude.save(function(err){
          if (err) return res.json(400, err);
          return res.json(200, solicitude);
        });
      });

    }
  });

};

exports.show = function(req, res){
  Solicitude.findById(req.params.id)
  .populate('createdBy')
  .populate('ticket.category')
  .populate('involved.user')
  .populate('comments.createdBy')
  .populate('comments.involved.user')
  .exec(function(err, solicitude){
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

    var createdBy = req.user ? req.user.userInfo.id : null;
    User.findById(createdBy, function(err, user){
      if (err) return false;
      var _comment = {}
      var _involved = [];

      _involved.push({
        user: user._id,
        role: user.role,
        isRead: false,
        readedAt: null
      });
      //attachments: [{ type: Types.ObjectId, ref: 'Attachment' }],
      _comment = {
        content: req.body.comment,
        involved: _involved,
        createdBy: createdBy
      }
      solicitude.comments.push(_comment);

      solicitude.save(function(err){
        if (err) return res.json(400, err);
        return res.json(200, solicitude);
      });
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
