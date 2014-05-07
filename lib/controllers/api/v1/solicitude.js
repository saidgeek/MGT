'use strict';

var mongoose = require('mongoose'),
    ObjectId = mongoose.Schema.Types.ObjectId,
    Solicitude = mongoose.model('Solicitude'),
    User = mongoose.model('User');

exports.list = function(req, res) {

  var _state = [''];
  if (!(req.query.state instanceof Array)) {
    _state[0] = req.query.state.toString();
  } else {
    _state = req.query.state;
  };

  var _category = req.query.category,
      _involved = req.query.involved,
      _priority = req.query.priority;

  var array = "[\""+_state.join("\",\"").toString()+"\"]";

  var query = "{ \"state."+req.user.userInfo.role+"\": { \"$in\": "+array+" } }";
  if (_category !== '' && _category !== null) {
    query = "{ \"state."+req.user.userInfo.role+"\": { \"$in\": "+array+" }, \"ticket.category\": \""+_category+"\" }";
  }
  if (_priority !== '' && _priority !== null) {
    query = "{ \"state."+req.user.userInfo.role+"\": { \"$in\": "+array+" }, \"priority\": \""+_priority+"\" }";
  }
  if (_involved !== '' && _involved !== null) {
    query = "{ \"state."+req.user.userInfo.role+"\": { \"$in\": "+array+" }, \"involved.user\": \""+_involved+"\" }";
  }

  Solicitude.find(JSON.parse(query))
  .populate('createdBy')
  .populate('responsible')
  .populate('provider')
  .populate('ticket.category')
  .populate('involved.user')
  .populate('comments.createdBy')
  .populate('comments.involved.user')
  .populate('ticket.attachments.createdBy')
  .sort('-createdAt, -_id')
  .exec(function(err, solicitudes){
    if (err) return res.json(400, err);
    if (!solicitudes) return res.json(404);
    return res.json(200, solicitudes);
  });
};

exports.groups = function (req, res) {
  var _states, _priorities;
  // { $match: { 'state.type': { $in: req.query.states }  } },
  var array = "[\""+req.query.states.join("\",\"").toString()+"\"]";
  var filter = '$state.type';
  var match = "{ \"state.type\": { \"$in\": "+array+" } }";
  if (!~['ROOT', 'ADMIN'].indexOf(req.user.userInfo.role)) {
    filter = '$state.'+req.user.userInfo.role;
    match = "{ \"state."+req.user.userInfo.role+"\": { \"$in\": "+array+" } }"
  }

  Solicitude.aggregate([{ $match: JSON.parse(match) }, { $group: { _id: filter, count: { $sum: 1 } } }], function (err, states) {
    if (err) return res.json(400, err);
    if (!states) return res.json(404);
    _states = states;
    Solicitude.aggregate([{ $match: JSON.parse(match) }, { $group: { _id: '$priority', count: { $sum: 1 } } }], function (err, priorities) {
      if (err) return res.json(400, err);
      if (!priorities) return res.json(404);
      _priorities = priorities;
      return res.json(200, { states: _states, priorities: _priorities });
    });
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
        if (typeof(req.body.solicitude.attachments) !== 'undefined' && req.body.solicitude.attachments.length > 0) {
          solicitude.ticket.attachments = req.body.solicitude.attachments;
        };
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
  .populate('responsible')
  .populate('provider')
  .populate('ticket.category')
  .populate('involved.user')
  .populate('comments.createdBy')
  .populate('comments.involved.user')
  .populate('ticket.attachments.createdBy')
  .exec(function(err, solicitude){
    if (err) return res.json(400, err);
    if (!solicitude) return res.json(404);
    return res.json(200, solicitude);
  });
};

exports.update = function(req, res){
  if (!req.body.solicitude) return res.json(403);

  Solicitude.findById(req.params.id, function (err, solicitude) {

    if (err) return res.json(400, err);
    if (!solicitude) return res.json(404);
    solicitude.updatedBy = req.user ? req.user.userInfo.id : null

    // ESTADO AL QUE PASARA LA SOLICITUD
    solicitude.nextState = req.body.solicitude.nextState;
    // SI EL ESTADO ES QUEUE_VALIDATION
    if (typeof(req.body.solicitude.priority) !== 'undefined') solicitude.priority = req.body.solicitude.priority;
    if (typeof(req.body.solicitude.responsible && ~['QUEUE_VALIDATION', 'ASSIGNED_TO_MANAGER', 'ASSIGNED_TO_PROVIDER'].indexOf(solicitude.state.type)) !== 'undefined') {
      solicitude.responsible = req.body.solicitude.responsible
    };
    if (typeof(req.body.solicitude.ticket.category) !== 'undefined') solicitude.ticket.category = req.body.solicitude.ticket.category;
    if (typeof(req.body.solicitude.tags) !== 'undefined') solicitude.ticket.tags = req.body.solicitude.ticket.tags;
    // SI EL ESTADO ES QUEUE_ALLOCATION

    if (typeof(req.body.solicitude.provider) !== 'undefined' && ~['QUEUE_VALIDATION', 'ASSIGNED_TO_MANAGER', 'ASSIGNED_TO_PROVIDER'].indexOf(solicitude.state.type)) {
      solicitude.provider = req.body.solicitude.provider
    };
    if (typeof(req.body.solicitude._duration) !== 'undefined') solicitude._duration = req.body.solicitude._duration;

    if (typeof(req.body.solicitude.message) !== 'undefined') {
      solicitude.message = {
        state: req.body.solicitude.nextState,
        message: req.body.solicitude.message,
        createdBy: req.user ? req.user.userInfo.id : null
      };
    };

    // COSAS ESEPCIONALES DE CADA ESTADO
    if (req.body.solicitude.nextState === 'queue_allocation') {
      for (var s in req.body.solicitude.ticket.segments) {
        if (req.body.solicitude.ticket.segments[s] !== null) {
          solicitude.ticket.segments.push(req.body.solicitude.ticket.segments[s]);
        }
      }
      for(var s in req.body.solicitude.ticket.sections) {
        if (req.body.solicitude.ticket.sections[s] !== null) {
          solicitude.ticket.sections.push(req.body.solicitude.ticket.sections[s]);
        }
      }
    };

    // AGREGANDOO LOS USUARIOS INVOLUCRADOS
    var _userId = req.body.solicitude.responsible || req.body.solicitude.provider

    if (~['QUEUE_VALIDATION', 'ASSIGNED_TO_MANAGER', 'ASSIGNED_TO_PROVIDER'].indexOf(solicitude.state.type.toString())) {
      User.findById(_userId, function(err, user){
        if (err) return res.json(400, err);

        solicitude.involved.push({
          user: user._id,
          role: user.role,
          isRead: false,
          readedAt: null
        });

        solicitude.action = 'update_state';

        solicitude.save(function (err) {
          if (err) return res.json(400, err);
          return res.json(200, solicitude);
        });
      });
    } else {
      solicitude.save(function (err) {
        if (err) return res.json(400, err);
        return res.json(200, solicitude);
      });
    };


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
    solicitude.action = 'add_task';
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
        createdBy: createdBy,
        attachments: req.body.attachments
      }
      solicitude.comments.push(_comment);

      solicitude.action = 'add_comment';

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
