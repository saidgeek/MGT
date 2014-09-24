'use strict';

var mongoose = require('mongoose'),
    ObjectId = mongoose.Schema.Types.ObjectId,
    Solicitude = mongoose.model('Solicitude'),
    Attachment = mongoose.model('Attachment'),
    Comment = mongoose.model('Comment'),
    User = mongoose.model('User');

exports.list = function(req, res) {

  var _state = [''];
  var _target = req.params.target;

	var perPage = 10;
  if (typeof(req.query.perPage) !== 'undefined') {
    perPage = req.query.perPage;
  };
  var page = 0;
  if (typeof(req.query.page) !== 'undeined') {
    page = req.query.page;
  };

  if (typeof(req.params.target) !== 'undefined' && req.params.target !== null && req.params.target === 'category') {
    _target = "ticket."+req.params.target;
  };

  if (_target === 'state') {
    _state[0] = req.params.filter.toUpperCase().toString();
  } else {
    _state = req.user.userInfo.permissions.states.join("\",\"").toString();
  };

  var _states = "[\""+_state+"\"]";

  var query = "{ ";

  query += "\"state."+req.user.role+"\": { \"$in\": "+_states+"}"

  if (typeof(_target) !== 'undefined' && _target !== 'state' && req.params.filter !== null) {
    query += ", \""+ _target +"\": \""+ req.params.filter.toUpperCase() +"\"";
  };

  if (['ROOT', 'ADMIN'].indexOf(req.user.role) < 0 && req.user.role === 'CLIENT') {
    query += ", \"applicant\": \"" + req.user.id + "\" "
  };

  if (['ROOT', 'ADMIN'].indexOf(req.user.role) < 0 && req.user.role === 'PROVIDER') {
    query += ", \"provider\": \"" + req.user.id + "\" "
  };

  if (['ROOT', 'ADMIN'].indexOf(req.user.role) < 0 && req.user.role === 'CONTENT_MANAGER') {
    query += ", \"responsible\": \"" + req.user.id + "\" "
  };

  if (['ROOT', 'ADMIN'].indexOf(req.user.role) < 0 && req.user.role === 'EDITOR') {
    query += ", \"editor\": \"" + req.user.id + "\" "
  };

  query += "}";

  Solicitude.find(JSON.parse(query))
  .populate('createdBy')
  .populate('responsible')
  .populate('provider')
  .populate('ticket.category')
  .populate('involved.user')
  .populate('comments.createdBy')
  .populate('comments.involved.user')
	.limit(perPage)
	.skip(perPage * page)
  .sort('-createdAt, -_id')
  .exec(function(err, solicitudes){
    if (err) return res.json(400, err);
    if (!solicitudes) return res.json(404);

		Solicitude.count(JSON.parse(query)).exec(function(err, count){
		  if (err) return res.json(400, err);

		  return res.json(200, { solicitudes: solicitudes, totalItems: count });

		});
  });
};

exports.search = function(req, res) {

  if (!req.params.q) return res.json(403);

  Solicitude.searching(req.params.q, req.user.userInfo, function(err, solicitudes) {
    if (err) return res.json(400, err);
    return res.json(200, solicitudes);
  });

};

exports.groups = function (req, res) {
  var _states, _priorities;
  // { $match: { 'state.type': { $in: req.query.states }  } },
  var array = "[\""+req.user.userInfo.permissions.states.join("\",\"").toString()+"\"]";
  var query = "{ ";

  if (!~['ROOT', 'ADMIN'].indexOf(req.user.role) && typeof(req.query.user_id) === 'undefined' && typeof(req.query.role) === 'undefined') {
    query += " \"state."+req.user.userInfo.role+"\": { \"$in\": "+array+" } "
  } else {
    query += "\"state.type\": { \"$in\": "+array+" } ";
  }

  var _user_id = req.query.user_id || req.user.id;
  var _role = req.query.role || req.user.role;

  if (['ROOT', 'ADMIN'].indexOf(_role) < 0) {
    switch(_role) {
      case 'CLIENT':
        query += ", \"applicant\": \"" + _user_id + "\" ";
        break;
      case 'PROVIDER':
        query += ", \"provider\": \"" + _user_id + "\" ";
        break;
      case 'CONTENT_MANAGER':
        query += ", \"responsible\": \"" + _user_id + "\" ";
        break;
      case 'EDITOR':
        query += ", \"editor\": \"" + _user_id + "\" ";
        break;
    };
  };

  query += "}";

  var STATES = req.query.states;
  var PRIORITIES = ['INCIDENCE','HIGH','AVERAGE','DECLINE'];

  Solicitude.where(JSON.parse(query)).exec(function(err, solicitudes) {

    if (err) return res.json(400, err);
    if (!solicitudes) return res.json(404);

    var _states = [];
    var _priorities = [];

    for (var i = 0; i < STATES.length; i++) {
      var count = 0;
      for (var e = 0; e < solicitudes.length; e++) {
        var solicitude = solicitudes[e];
        if (solicitude.state[req.user.role].toString() === STATES[i].toString()) {
          count++;
        };
      };
      _states.push({ _id: STATES[i], count: count });
    };

    for (var i = 0; i < PRIORITIES.length; i++) {
      var count = 0;
      for (var e = 0; e < solicitudes.length; e++) {
        var solicitude = solicitudes[e];
        if (typeof(solicitude.priority) !== 'undefined' && solicitude.priority !== null && solicitude.priority.toString() === PRIORITIES[i].toString()) {
          count++;
        };
      };
      _priorities.push({ _id: PRIORITIES[i], count: count });
    };

    return res.json(200, { states: _states, priorities: _priorities });

  });

}

exports.create = function(req, res) {

  if (!req.params.client_id) return res.json(403);
  if (!req.body.solicitude) return res.json(403);

  User.findOne({ role: 'EDITOR' }, function (err, user) {

    var solicitude = new Solicitude();

    solicitude.ticket = {
      title: req.body.solicitude.ticket.title,
      description: req.body.solicitude.ticket.description
    };

    solicitude.applicant = req.params.client_id;
    solicitude.editor = user._id;
    solicitude.createdBy = req.params.client_id;

    solicitude.save(function(err){
      if (err) return res.json(400, err);

      if (typeof(req.body.solicitude.attachments) !== 'undefined' && req.body.solicitude.attachments.length > 0) {
        Attachment.add({ name: 'Solicitude', id: solicitude._id }, solicitude._id, req.body.solicitude.attachments, req.params.client_id, function(err, atts) {
          if (!err) {
            solicitude.attachments = atts;
            solicitude.save(function(err) {
              if (err) return res.json(400, err);
              return res.json(200, solicitude);
            });
          };
        });
      } else {
        return res.json(200, solicitude);
      };
    });
  });

};

exports.show = function(req, res){
  Solicitude.findById(req.params.id)
  .populate('createdBy')
  .populate('applicant')
  .populate('editor')
  .populate('responsible')
  .populate('provider')
  .populate('ticket.category')
  .populate('involved.user')
  .populate('comments.createdBy')
  .populate('attachments')
  .exec(function(err, solicitude){
    if (err) return res.json(400, err);
    if (!solicitude) return res.json(404);

    var _involved = [];
    for (var i = 0; i < solicitude.involved.length; i++) {
      if (solicitude.involved[i].role === 'CONTENT_MANAGER') {
        _involved.push(solicitude.involved[i]);
      };
    };

    solicitude.involved = _involved;

    return res.json(200, solicitude);
  });
};

exports.update = function(req, res){

  if (!req.body.solicitude) return res.json(403);

  Solicitude.findById(req.params.id, function (err, solicitude) {
    console.log('err 1:', err);
    if (err) return res.json(400, err);
    if (!solicitude) return res.json(404);
    solicitude.updatedBy = req.user ? req.user.userInfo.id : null

    // ESTADO AL QUE PASARA LA SOLICITUD
    if (typeof(req.body.solicitude.nextState) !== 'undefined') solicitude.nextState = req.body.solicitude.nextState;
    // SI EL ESTADO ES QUEUE_VALIDATION
    if (typeof(solicitude.priority) === 'undefined' || solicitude.priority === null || solicitude.priority !== req.body.solicitude.priority) solicitude.priority = req.body.solicitude.priority || null;
    if (solicitude.responsible === null) solicitude.responsible = req.body.solicitude.responsible || null;
    if (typeof(solicitude.ticket.category) === 'undefined' || solicitude.ticket.category === null) solicitude.ticket.category = req.body.solicitude.ticket.category || null;
    if (solicitude.ticket.tags === null) solicitude.ticket.tags = req.body.solicitude.ticket.tags || null;
    // if (typeof(req.body.solicitude.priority) !== 'undefined') solicitude.priority = req.body.solicitude.priority;
    // if (typeof(req.body.solicitude.responsible) !== 'undefined' && ['QUEUE_VALIDATION'].indexOf(solicitude.state.type) > -1) {
    //   solicitude.responsible = req.body.solicitude.responsible
    // };
    // if (typeof(req.body.solicitude.ticket.category) !== 'undefined' && solicitude.state.type.toString() === 'ASSIGNED_TO_MANAGER') solicitude.ticket.category = req.body.solicitude.ticket.category;

    // if (typeof(req.body.solicitude.ticket.tags) !== 'undefined') solicitude.ticket.tags = req.body.solicitude.ticket.tags;

    // SI EL ESTADO ES QUEUE_ALLOCATION
    if (solicitude.provider === null) solicitude.provider = req.body.solicitude.provider || null;
    // if (solicitude._duration === null) solicitude._duration = req.body.solicitude._duration || null;
    // if (typeof(req.body.solicitude.provider) !== 'undefined' && ['ASSIGNED_TO_PROVIDER'].indexOf(solicitude.state.type) > -1) {
    //   solicitude.provider = req.body.solicitude.provider
    // };
    if (typeof(req.body.solicitude._duration) !== 'undefined') solicitude._duration = req.body.solicitude._duration;

    if (typeof(req.body.solicitude.message) !== 'undefined') {

      var to = null;
      if (solicitude.state.type === 'CANCELED') {
        Comment.add('Solicitude.pm', solicitude.applicant, req.params.id, req.body.solicitude.message, [], solicitude.updatedBy);
        Comment.add('Solicitude.internal', solicitude.responsible, req.params.id, req.body.solicitude.message, [], solicitude.updatedBy);
        Comment.add('Solicitude.provider', solicitude.provider, req.params.id, req.body.solicitude.message, [], solicitude.updatedBy);
      };
      if (['PAUSED', 'REJECTED_BY_MANAGER', 'ASSIGNED_TO_PROVIDER'].indexOf(solicitude.state.type) > -1) {
        Comment.add('Solicitude.provider', solicitude.provider, req.params.id, req.body.solicitude.message, [], solicitude.updatedBy);
      };
      if (['REJECTED_BY_CLIENT', 'ASSIGNED_TO_MANAGER', 'PROCCESS'].indexOf(solicitude.state.type) > -1) {
        Comment.add('Solicitude.internal', solicitude.responsible, req.params.id, req.body.solicitude.message, [], solicitude.updatedBy);
      };
    };

    // COSAS ESEPCIONALES DE CADA ESTADO
    if (typeof(req.body.solicitude.nextState) !== 'undefined' && req.body.solicitude.nextState.toString() === 'assigned_to_manager') {
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

    console.log('solicitude:', solicitude);

    solicitude.save(function (err) {
      console.log('err 2:', err);
      if (err) return res.json(400, err);
      return res.json(200, solicitude);
    });


  });

};

exports.addComments = function(req, res){
  if (!req.body.comment) return res.json(403);
  Solicitude.findById(req.params.id).exec(function(err, solicitude){
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
          name: req.body.attachments[i].name,
          link: req.body.attachments[i].url
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
        Solicitude.findById(solicitude._id)
          .populate('comments.createdBy')
          .populate('comments.involved.user')
          .exec(function(err, _solicitude){
            return res.json(200, _solicitude);
          });
      });
    });
  });
};

exports.addTasks = function(req, res){
  if (!req.body.desc) return res.json(403);
  Solicitude.findById(req.params.id, function(err, solicitude){
    if (err) return res.json(400, err);
    if (!solicitude) return res.json(404);

    var createdBy = req.user ? req.user.userInfo.id : null;

    var _attachments = [];
    if (typeof(req.body.attachments) !== 'undefined') {
      for (var i = 0; i < req.body.attachments.length ; i++) {
        _attachments.push({
          id: req.body.attachments[i].referer.id,
          name: req.body.attachments[i].name,
          link: req.body.attachments[i].url
        });
      };
    }

    var _task = {
      description: req.body.desc,
      attachments: _attachments,
      createdBy: createdBy
    };

    for (var i = 0; i < req.body.attachments.length; i++) {
      solicitude.attachments.push(req.body.attachments[i]);
    };

    solicitude.tasks.push(_task);

    solicitude.action = 'add_task';

    solicitude.save(function(err){
      if (err) return res.json(400, err);
      return res.json(200, solicitude);
    });
  });
};

exports.toggleCheckTask = function(req, res){
  Solicitude.findById(req.params.id, function(err, solicitude){
    if (err) return res.json(400, err);
    if (!solicitude) return res.json(404);

    for (var i = 0; i < solicitude.tasks.length; i++) {
      if (solicitude.tasks[i]._id.toString() === req.params.task.toString()) {
        solicitude.tasks[i].check = !solicitude.tasks[i].check;
      };
    };

    solicitude.action = 'toggle_check_task';

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
