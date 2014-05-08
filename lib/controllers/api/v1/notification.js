'use strict';

var mongoose = require('mongoose'),
    Notification = mongoose.model('Notification');

exports.index = function(req, res) {
  Notification.find({ to: req.query.userId })
  .populate('from')
  .sort('-createdAt, -_id')
  .exec(function(err, notifications){
    if (err) return res.json(400, err);
    if (!notifications) return res.json(404);
    return res.json(200, notifications);
  });
};
