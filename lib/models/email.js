'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Type = Schema.Types,
    ejs = require('ejs');

var EmailSchema = new Schema({
  to: Array,
  html: String,
  text: String,
  subject: String,
  state: { type: String, default: 'QUEUE' },
  createdAt: { type: Date, default: Date.now() }
});

EmailSchema.virtual('content').set(function(data) {
  var template = require('../email_template/'+data.type);
  var _html = ejs.render(template.html, data.data);
  var _text = ejs.render(template.text, data.data);
  this.html = _html;
  this.text = _text;
});

EmailSchema.post('save', function() {
  // crear job
  jobs.create('sendEmail', { id: this._id }).priority('high').save();
});

module.exports = mongoose.model('Email', EmailSchema);