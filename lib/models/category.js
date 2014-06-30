'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types;

var CategorySchema = new Schema({
  name: String,
  description: String,
  deleteMessage: String,
  deletedAt: { type: Date, default: null },
  deletedBy: { type: Types.ObjectId, ref: 'User' },
  updatedBy: { type: Types.ObjectId, ref: 'User' },
  createdAt: { type: Date, default: Date.now() },  
  createdBy: { type: Types.ObjectId, ref: 'User' }
});

CategorySchema.pre('save', function (next) {
  if (this.isNew) {
    jobs.create('CreateLog', {
      user: this.createdBy,
      action: 'created',
      _class: this.constructor.modelName,
      _classId: this._id,
      data: this
    })
    .priority('normal')
    .save();
  }

  if (!this.isNew) {
    jobs.create('CreateLog', {
      user: this.createdBy,
      action: 'update',
      _class: this.constructor.modelName,
      _classId: this._id,
      data: this
    })
    .priority('normal')
    .save();
  }
  next();
});

CategorySchema.post('save', function (next) {
  jobs.create('CreateLog', {
    user: this.createdBy,
    action: 'remove',
    _class: this.constructor.modelName,
    _classId: this._id,
    description: this.deleteMessage,
    data: this
  })
  .priority('normal')
  .save();
});

module.exports = mongoose.model('Category', CategorySchema);
