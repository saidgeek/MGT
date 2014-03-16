'use strict';

var mongoose = require('mongoose'),
    Category = mongoose.model('Category');

exports.list = function(req, res) {
  Category.find({}, function(err, categories){
    if (err) return res.json(400, err);
    if (!categories) return res.json(404);
    return res.json(200, categories);
  });
};

exports.create = function(req, res) {
  if (!req.body.category) return res.json(403);
  var category = new Category(req.body.category);
  category.createdBy = req.user ? req.user.userInfo.id : null
  category.save(function(err){
    if (err) return res.json(400, err);
    return res.json(200, category);
  });
};

exports.show = function(req, res) {
  Category.findById(req.params.id, function(err, category){
    if (err) return res.json(400, err);
    if (!category) return res.json(404);
    return res.json(200, category);
  });
};

exports.update = function(req, res) {
  if (!req.body.category) return res.json(403);
  Category.findByIdAndUpdate(req.params.id, req.body.category, function(err, category){
    if (err) return res.json(400, err);
    if (!category) return res.json(404);
    return res.json(200, category);
  });
};