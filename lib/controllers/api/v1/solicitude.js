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
  var query = "{ ";
  if (typeof(req.params.id) !== 'undefined' && req.params.id !== null) {
    query += "_id: "+req.params.id+", ";
  };
  query += "\"state."+req.user.userInfo.role+"\": { \"$in\": "+array+"}"
  if (_category !== '' && _category !== null) {
    query += ", \"ticket.category\": \""+_category+"\"";
  }
  if (_priority !== '' && _priority !== null) {
    query = ", \"priority\": \""+_priority+"\"";
  }
  if (_involved !== '' && _involved !== null) {
    query = ", \"involved.user\": \""+_involved+"\"";
  }
  query += "}";

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
        role: ['ADMIN', 'ROOT'].indexOf(user.role) > -1 ? 'CLIENT' : user.role,
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
        console.log('req.body.solicitude.attachments:', req.body.solicitude.attachments);
        if (typeof(req.body.solicitude.attachments) !== 'undefined' && req.body.solicitude.attachments.length > 0) {
          solicitude.attachments = req.body.solicitude.attachments;
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
    if (typeof(req.body.solicitude.responsible) !== 'undefined' && ['QUEUE_VALIDATION'].indexOf(solicitude.state.type) > -1) {
      solicitude.responsible = req.body.solicitude.responsible
    };
    if (typeof(req.body.solicitude.ticket.category) !== 'undefined' && solicitude.state.type.toString() === 'ASSIGNED_TO_MANAGER') solicitude.ticket.category = req.body.solicitude.ticket.category;
    
    if (typeof(req.body.solicitude.ticket.tags) !== 'undefined') solicitude.ticket.tags = req.body.solicitude.ticket.tags;
    // SI EL ESTADO ES QUEUE_ALLOCATION

    if (typeof(req.body.solicitude.provider) !== 'undefined' && ['ASSIGNED_TO_PROVIDER'].indexOf(solicitude.state.type) > -1) {
      solicitude.provider = req.body.solicitude.provider
    };
    if (typeof(req.body.solicitude._duration) !== 'undefined') solicitude._duration = req.body.solicitude._duration;

    if (typeof(req.body.solicitude.message) !== 'undefined' && ['PAUSED', 'REJECTED_BY_CLIENT', 'REJECTED_BY_MANAGER'].indexOf(solicitude.state.type) > -1) {
      solicitude.message = {};
      solicitude.message[req.body.solicitude.nextState] = {
        content: req.body.solicitude.message,
        createdBy: req.user ? req.user.userInfo.id : null
      }
    };if (solicitude.state.type === 'PAUSED') {
      solicitude.pausedAt = Date.now()
    };

    // COSAS ESEPCIONALES DE CADA ESTADO
    if (req.body.solicitude.nextState.toString() === 'assigned_to_manager') {
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
    var _userId = null

    if (typeof(req.body.solicitude.responsible) !== 'undefined' && typeof(req.body.solicitude.responsible) !== 'Object') {
      _userId = req.body.solicitude.responsible;
    };
    if (typeof(req.body.solicitude.provider) !== 'undefined' && typeof(req.body.solicitude.provider) !== 'Object') {
      _userId = req.body.solicitude.provider;
    };

    if (_userId !== null && ~['QUEUE_VALIDATION', 'ASSIGNED_TO_MANAGER', 'ASSIGNED_TO_PROVIDER'].indexOf(solicitude.state.type.toString())) {
      User.findById(_userId, function(err, user){
        if (err) return res.json(400, err);

        solicitude.involved.push({
          user: user._id,
          role: user.role,
          isRead: false,
          readedAt: null
        });

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
      var _ids = [];
      for (var i = 0; i < req.body.attachments.length ; i++) {
        _ids.push({
          id: req.body.attachments[i].referer.id,
          name: req.body.attachments[i].name
        });
      };

      _comment = {
        content: req.body.comment,
        attachments: _ids,
        involved: _involved,
        createdBy: createdBy
      }
      solicitude.comments.push(_comment);

      for (var i = 0; i < req.body.attachments.length; i++) {
        solicitude.attachments.push(req.body.attachments[i]);
      };

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
