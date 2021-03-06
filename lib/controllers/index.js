'use strict';

var path = require('path');

/**
 * Send partial, or 404 if it doesn't exist
 */
exports.partials = function(req, res) {
  var stripped = req.url.split('.')[0];
  var requestedView = path.join('./', stripped);
  res.render(requestedView, function(err, html) {
    if(err) {
      console.log("Error rendering partial '" + requestedView + "'\n", err);
      res.status(404);
      res.send(404);
    } else {
      res.send(html);
    }
  });
};

/**
 * Send directives, or 404 if it doesn't exist
 */
exports.directives = function(req, res) {
  var stripped = req.url.split('.')[0];
  var requestedView = path.join('./', stripped);
  res.render(requestedView, function(err, html) {
    if(err) {
      console.log("Error rendering directives '" + requestedView + "'\n", err);
      res.status(404);
      res.send(404);
    } else {
      res.send(html);
    }
  });
};

exports.auth = function(req, res) {
  res.render('auth');
};

exports.admin = function(req, res) {
  res.render('admin');
};

/**
 * Send our single page app
 */
exports.index = function(req, res) {
  if (typeof(req.user) !== 'undefined' && req.user !== null) {
    res.render('index');
  } else {
    res.redirect('/auth/')
  };
};
