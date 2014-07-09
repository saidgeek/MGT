'use strict';

var mongoose = require('mongoose'),
    Comment = mongoose.model('Comment'),
    Attachment = mongoose.model('Attachment');

exports.index = function(req, res) {

  if (!req.params.solicitude_id) return res.json(403);

  Comment.find()
    .where({ solicitude: req.params.solicitude_id })
    .populate('attachments')
    .sort('createdAt')
    .exec(function(err, comments) {
      if (err) return res.json(400, err);

      return res.json(200, comments);
    });

};

exports.create = function(req, res) {

  console.log('req.params.solicitude_id:', req.params.solicitude_id);
  console.log('req.params.to:', req.params.to);
  console.log('req.body.comment:', req.body.comment);
  console.log('req.body.createdBy:', req.body.createdBy);

  if (!req.params.type) return res.json(403);
  if (!req.params.solicitude_id) return res.json(403);
  if (!req.params.to) return res.json(403);
  if (!req.body.comment) return res.json(403);
  if (!req.body.createdBy) return res.json(403);

  var comment = new Comment();

  comment.type = 'Solicitude.'+req.params.type;
  comment.to = req.params.to;
  comment.solicitude = req.params.solicitude_id;
  comment.message = req.body.comment.message;
  comment.createdBy = req.body.createdBy;

  comment.save(function(err) {
    if (err) return res.json(400, err);
    if (typeof(req.body.comment.attachments) !== 'undefined' && req.body.comment.attachments.length > 0) {
      Attachment.add({ name: 'Comment', id: comment._id }, req.params.solicitude_id, req.body.comment.attachments, req.body.createdBy, function(err, atts) {
        if (!err) {
          comment.attachments = atts;
          comment.save(function(err) {
            if (err) return res.json(400, err);
            return res.json(200, comment);
          });
        };
      });
    } else {
      return res.json(200, comment);
    };
  });

};

exports.task = function(req, res) {

  console.log('req.params.solicitude_id:', req.params.solicitude_id);
  console.log('req.params.task_id:', req.params.task_id);
  console.log('req.body.comment:', req.body.comment);
  console.log('req.body.createdBy:', req.body.createdBy);

  if (!req.params.solicitude_id) return res.json(403);
  if (!req.params.task_id) return res.json(403);
  if (!req.body.comment) return res.json(403);
  if (!req.body.createdBy) return res.json(403);

  var comment = new Comment();

  comment.type = 'Task';
  comment.solicitude = req.params.solicitude_id;
  comment.task = req.params.task_id;
  comment.message = req.body.comment.message;
  comment.createdBy = req.body.createdBy;

  comment.save(function(err) {
    if (err) return res.json(400, err);
    if (typeof(req.body.comment.attachments) !== 'undefined' && req.body.comment.attachments.length > 0) {
      Attachment.add({ name: 'Comment', id: comment._id }, req.params.solicitude_id, req.body.comment.attachments, req.body.createdBy, function(err, atts) {
        if (!err) {
          comment.attachments = atts;
          comment.save(function(err) {
            if (err) return res.json(400, err);
            return res.json(200, comment);
          });
        };
      });
    } else {
      return res.json(200, comment);
    };
  });

};