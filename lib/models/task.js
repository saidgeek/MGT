'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types;


var TaskSchema = new Schema({
  content: { type: String, default: null },
  isComplete: { type: Boolean, default: false },
  solicitude: { type: Types.ObjectId, ref: 'Solicitude' },
  attachments: [
    { type: Types.ObjectId, ref: 'Attachmants' }
  ],
  completedAt: { type: Date, default: null },
  createdBy: { type: Types.ObjectId, ref: 'User' },
  createdAt: { type: Date, default: null }
});

TaskSchema.pre('save', function(next) {
  this.wasNew = this.isNew;

  if (this.isNew) {
    this.createdAt = Date.now();
  };

  next();
});

module.exports = mongoose.model('Task', TaskSchema);