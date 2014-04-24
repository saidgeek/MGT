'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Type = Schema.Types,
    ejs = require('ejs'),
    makeEmail = require('../makeEmail');

var EmailSchema = new Schema({
  to: Array,
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
  if (this.isNew) {
    var email = new makeEmail({
      id: this._id,
      html: this.html,
      text: this.text,
      subject: this.subject,
      to: this.to
    });
    var that = this;
    email.send();
  }
  next();
});

module.exports = mongoose.model('Email', EmailSchema);
