'use strict';

var mongoose = require('mongoose'),
    Category = mongoose.model('Category'),
    Solicitude = mongoose.model('Solicitude');

exports.list = function(req, res) {
  Category.find({ deletedAt: null }, function(err, categories){
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
  Category.findById(req.params.id, function(err, category){
    if (err) return res.json(400, err);
    if (!category) return res.json(404);
    category.updatedBy = req.user ? req.user.userInfo.id : null
    category.name = req.body.category.name
    category.description = req.body.category.description
    category.tags = req.body.category.tags
    category.save(function(err) {
      if (err) return res.json(400, err);
      return res.json(200, category);
    });
  });
};

exports.remove = function (req, res) {
  if (!req.query.category) return res.json(403);
  Category.findById(req.params.id, function (err, category) {
    if (err) return res.json(400, err);
    if (!category) return res.json(404);

    category.deletedBy = req.user ? req.user.userInfo.id : null;
    category.deletedAt = Date.now();
    category.deleteMessage = req.query.category.deleteMessage;

    category.save(function (err) {
      if (err) return res.json(400, err);
      if (req.query.category.newCategory?) {
        Solicitude.where({ 'ticket.category': req.params.id }).update({ 'ticket.category': req.query.category.newCategory }).exec();
      };
      return res.json(200, category);
    });
  });
}
