'use strict';

var mongoose = require('mongoose'),
    Attachment = mongoose.model('Attachment');

exports.index = function(req, res) {

  if (!req.params.solicitude_id) return res.json(403);

  Attachment.find({ solicitude: req.params.solicitude_id }, function(err, attachments) {
    if (err) return res.json(400, err);
    return res.json(200, attachments);
  });

};