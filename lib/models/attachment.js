'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types;

var AttachmentSchema = new Schema({
  name: String,
  url: String,
  ext: String,
  createdBy: { type: Types.ObjectId, ref: 'User' },
  createdAt: { type: Date, default: Date.now() }
});

module.exports = mongoose.model('Attachment', AttachmentSchema);