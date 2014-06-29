'use strict';

var mongoose = require('mongoose'),
    Token = mongoose.model('Token');
/**
 * Custom middleware used by the application
 */
module.exports = {

  /**
   *  Protect routes on your api from unauthenticated access
   */
  auth: function auth(req, res, next) {
    if (req.isAuthenticated()) return next();
    res.send(401);
  },

  /**
   * Set a cookie for angular so it knows we have an http session
   */
  setUserCookie: function(req, res, next) {
    if(req.user) {
      res.cookie('user', JSON.stringify(req.user.userInfo));
    }
    next();
  },

  authenticateToken: function(req, res, next) {

    var _clientToken = req.headers['token-client'];
    var _accessToken = req.headers['token-access'];
      
    Token.findOne({clientToken: _clientToken, accessToken: _accessToken}, function(err, token){
      if (token.authenticate({clientToken: _clientToken, accessToken: _accessToken})) {
        return next();
      } else {
        return res.json(400, 'Access denied!');
      };
    });
    
  }
};