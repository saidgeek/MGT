'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Type = Schema.Types,
    ejs = require('ejs'),
    Mailer = require('../mailer');

var EmailSchema = new Schema({
  to: { type: String, default: null },
  cc: { type: String, default: null }, 
  html: String,
  text: String,
  subject: String,
  state: { type: String, default: 'QUEUE' },
  errDesc: { type: String, default: null },
  createdAt: { type: Date, default: Date.now() }
});

EmailSchema.virtual('content').set(function(data) {
  var template = require('../email_template/'+data.type);
  var _html = ejs.render(template.html, data.data);
  var _text = ejs.render(template.text, data.data);
  this.html = _html;
  this.text = _text;
});

EmailSchema.pre('save', function (next) {
  this.wasNew = this.isNew;
  next();
});

EmailSchema.post('save', function() {
  if (this.wasNew) {
    var mailer = new Mailer(this._id);
    mailer.send();
  };
});

module.exports = mongoose.model('Email', EmailSchema);
