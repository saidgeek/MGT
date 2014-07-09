'use strict';

var mongoose = require('mongoose'),
    Task = mongoose.model('Task');

exports.index =  function(req, res) {

  if (!req.params.solicitude_id) return res.json(403);

  Task.find({ solicitude: req.params.solicitude_id })
    .populate('createdBy')
    .exec(function(err, tasks) {
      if (err) return res.json(400, err);
      return res.json(200, tasks);
    });

};

exports.create =  function(req, res) {

  if (!req.params.solicitude_id) return res.json(403);
  if (!req.body.task) return res.json(403);
  if (!req.body.createdBy) return res.json(403);

  var task = new Task();

  task.content = req.body.task.content;
  task.solicitude = req.params.solicitude_id;
  task.createdBy = req.body.createdBy;

  task.save(function(err) {
    if (err) return res.json(400, err);
    if (typeof(req.body.task.attachments) !== 'undefined' && req.body.task.attachments.length > 0) {

      Attachment.add({ name: 'Task', id: task._id }, req.params.solicitude_id, req.body.task.attachments, req.body.createdBy, function(err, atts) {
        if (!err) {
          task.attachments = atts;
          task.save(function(err) {
            if (err) return res.json(400, err);
            return res.json(200, task);
          });
        };
      });

    } else {
      return res.json(200, task);
    };
  });


};

exports.toggleCompleted =  function(req, res) {

  if (!req.params.id) return res.json(403);

  Task.findById(req.params.id, function(err, task) {

    task.isComplete = !task.isComplete;

    task.save(function(err) {
      if (err) return res.json(400, err);
      return res.json(200);
    });

  });

};