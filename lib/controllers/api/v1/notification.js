'use strict';

var mongoose = require('mongoose'),
    Notification = mongoose.model('Notification');

exports.index = function(req, res) {
  Notification.find({ to: req.query.userId, isRead: false })
  .populate('from')
  .sort('-createdAt, -_id')
  .exec(function(err, notifications){
    if (err) return res.json(400, err);
    if (!notifications) return res.json(404);
    return res.json(200, notifications);
  });
};

exports.read = function(req, res) {

  Notification.findById(req.params.id, function(err, notification) {
    if (!err) {

      notification.isRead = true;
      notification.readedAt = Date.now();

      notification.save(function(err) {
        if (err) return res.json(400, err);
        return res.json(200);
      });

    };
  });

};

exports.read_all = function(req, res) {

  Notification.update({ to: req.query.userId, isRead: false }, { isRead: true, readedAt: Date.now() }, { multi: true }, function(err, numberAffected, raw) {
    if (!err) {
      if (err) return res.json(400, err);
      return res.json(200);
    };
  });

};
