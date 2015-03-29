'use strict';

var mongoose = require('mongoose'),
    User = mongoose.model('User'),
    Solicitude = mongoose.model('Solicitude'),
    Token = mongoose.model('Token'),
    passport = require('passport'),
    moment = require('moment'),
    async = require('async');


exports.list = function (req, res) {
  var _role = [''];

  if (typeof(req.query.role) == 'string') {
    _role[0] = req.query.role.toString();
  } else {
    _role = req.user.userInfo.permissions.roles;
  };

  User.find({ role: { $in: _role } })
    .exec(function (err, users) {
      if (err) return res.json(400, err);
      if (!users) return res.json(404);
      return res.json(200, users);
    });
};

exports.groups = function (req, res) {
  User.aggregate([{ $match: { role: { $in: req.user.userInfo.permissions.roles }  } }, { $group: { _id: '$role', count: { $sum: 1 } } }], function (err, groups) {
    if (err) return res.json(400, err);
    if (!groups) return res.json(404);
    return res.json(200, groups);
  });
}

/**
 * Create user
 */
exports.create = function (req, res) {
  if (req.body.user) {
    var token = new Token({
      description: 'User token',
      token: true,
      createdBy: req.user ? req.user.userInfo.id : null
    });
    var user = new User();
    user.email = req.body.user.email;
    user.role = req.body.user.role;
    user.provider = 'local';
    user.profile = {
      avatar: req.body.user.profile.avatar || '',
      firstName: req.body.user.profile.firstName,
      lastName: req.body.user.profile.lastName,
      description: req.body.user.profile.description,
      phoneNumber: req.body.user.profile.phoneNumber,
      celNumber: req.body.user.profile.celNumber,
      company: req.body.user.profile.company
    }
    user.access = {
      clientToken: token.clientToken,
      accessToken: token.accessToken
    }
    user.createdBy = req.user ? req.user.userInfo.id : null
    user.save(function(err){
      if (err) return res.json(400, err);
      token.save(function(err){
        if (err) return res.json(400, err);
        return res.json(200, user);
      });
    });
  } else {
    return res.json(400);
  };
};

/**
 *  Get profile of specified user
 */
exports.show = function (req, res) {
  User.findById(req.params.id, function (err, user) {
    if (err) return res.json(400, err);
    if (!user) return res.json(404);
    res.json(200, user);
  });
};

/**
* Update user
**/
exports.updateProfile = function(req, res) {
  User.findById(req.params.id, function(err, user){
    if (err) return res.json(400, err);
    if (!user) return res.json(403);
    user.updatedBy = req.user ? req.user.userInfo.id : null
    user.role = req.body.user.role;
    user.profile = {
      avatar: req.body.user.profile.avatar,
      firstName: req.body.user.profile.firstName,
      lastName: req.body.user.profile.lastName,
      description: req.body.user.profile.description,
      celNumber: req.body.user.profile.celNumber,
      phoneNumber: req.body.user.profile.phoneNumber,
      company: req.body.user.profile.company
    };
    user.save(function(err){
      if (err) return res.json(400, err);
      return res.json(200, user);
    });
  });
};

/**
 * Change password
 */
exports.changePassword = function(req, res) {
  User.findById(req.params.id, function (err, user) {
    if(user.authenticate(String(req.body.oldPassword))) {
      if (req.body.newPassword === req.body.confirmPassword) {
        user.password = String(req.body.newPassword);
        user.changePassword = Date.now();
        user.save(function(err) {
          if (err) return res.json(400, err);
          res.json(200);
        });
      }else {
        res.json(403);
      };
    } else {
      res.json(403);
    }
  });
};

/**
 * Delete user
 */
exports.delete = function(req, res) {
  User.findById(req.params.id, function(err, user){
    if (err) return res.json(400, err);
    if (!user) return res.json(404);
    user.remove(function(err){
      if (err) return res.json(400, err);
      return res.json(200);
    });
  });
};

/**
 * Get current user
 */
exports.me = function(req, res) {
  res.json(req.user || null);
};

exports.recovery = function(req, res) {
  User.findOne({email: req.body.email}, function(err, user){
    if (err) return res.json(400, err);
    if (!user) return res.json(404, {fail: true});
    user.recovery(function(err, u){
      if (err) res.json(400, err);
      if (!u) return res.json(404, {fail: true});
      return res.json(200, u);
    });
  });
};

exports.solicitudes = function(req, res) {

  if (!req.params.id) return res.json(404);
  if (!req.query.role) return res.json(404);

  var _state = [''];
  if (!req.query.state) {
    _state = req.user.userInfo.permissions.states.join("\",\"").toString();
  } else {
    _state[0] = req.query.state.toUpperCase().toString();
  };

  var _states = "[\""+_state+"\"]";
  var query = "{ ";

  query += "\"state."+req.query.role.toUpperCase()+"\": { \"$in\": "+_states+"}";

  if (['ROOT', 'ADMIN'].indexOf(req.user.role) < 0) {
    switch(req.query.role) {
      case 'CLIENT':
        query += ", \"applicant\": \"" + req.params.id + "\" ";
        break;
      case 'PROVIDER':
        query += ", \"provider\": \"" + req.params.id + "\" ";
        break;
      case 'CONTENT_MANAGER':
        query += ", \"responsible\": \"" + req.params.id + "\" ";
        break;
      case 'EDITOR':
        query += ", \"editor\": \"" + req.params.id + "\" ";
        break;
    }
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
  .limit(10)
  .sort('-createdAt, -_id')
  .exec(function(err, solicitudes){
    if (err) return res.json(400, err);
    if (!solicitudes) return res.json(404);

    Solicitude.count(JSON.parse(query)).exec(function(err, count){
      if (err) return res.json(400, err);


      async.series([
          function(callback){
            for (var i = 0; i < solicitudes.length; i++) {
              solicitudes[i]
              var now = moment(Date.now());
              var start = moment(solicitudes[i].startedAt);
              var end = moment(solicitudes[i].endedAt);

              var diff = end.diff(now, 'milliseconds');

              solicitudes[i].duration = diff;
            };
            callback(null, solicitudes);
          }
      ],
      // optional callback
      function(err, results){
        if (err) return res.json(400, err);
        return res.json(200, { resources: results[0], length: count });
      });

    });
  });

}
