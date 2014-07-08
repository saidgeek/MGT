'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types;

var AttachmentSchema = new Schema({
  referer: {
    id: String,
    name: String
  },
  solicitude: { type: Types.ObjectId, ref: 'User' },
  url: String,
  name: String,
  ext: String,
  size: Number,
  thumbnails: {},
  createdAt: { type: Date, default: null },
  createdBy: { type: Types.ObjectId, ref: 'User' },
});

AttachmentSchema.static('add', function(referer, solicitude_id, attachmants, createdBy, cb) {

  var ids = [];
  for (var i = 0; i < attachmants.length; i++) {
    var att = new this(attachmants[i]);
    att.referer = referer;
    att.solicitude = solicitude_id;
    att.save();
    ids.push(att._id);
  };
  console.log('ids:', ids);
  if (ids.length > 0) {
    cb(null, ids);
  } else {
    cb(true);
  };
  
});

AttachmentSchema.pre('save', function(next) {
  this.wasNew = this.isNew;

  if (this.isNew) {
    this.createdAt = Date.now();
  };

  next();
});

module.exports = mongoose.model('Attachment', AttachmentSchema);
