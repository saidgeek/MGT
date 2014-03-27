'use strict';

var mongoose = require('mongoose'),
    User = mongoose.model('User'),
    Token = mongoose.model('Token'),
    passport = require('passport');


exports.list = function (req, res) {
  User.find({}, function (err, users) {
    if (err) return res.json(400, err);
    if (!users) return res.json(404);
    return res.json(200, users);
  });
};

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
      celNumber: req.body.user.profile.celNumber
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
    user.profile = {
      firstName: req.body.profile.firstName,
      lastName: req.body.profile.lastName,
      description: req.body.profile.description,
      phoneNumber: req.body.profile.phoneNumber,
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








