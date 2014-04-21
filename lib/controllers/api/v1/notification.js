'use strict';

var mongoose = require('mongoose'),
    Notification = mongoose.model('Notification');

exports.index = function(req, res) {
  console.log(req.query);
  Notification.find({ to: req.query.userId })
  .populate('from')
  .exec(function(err, notifications){
    if (err) return res.json(400, err);
    if (!notifications) return res.json(404);
    return res.json(200, notifications);
  });
};
