'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types;

var CategorySchema = new Schema({
  name: String,
  description: String,
  createdAt: { type: Date, default: Date.now() },
  updatedBy: { type: Types.ObjectId, ref: 'Usert' },
  createdBy: { type: Types.ObjectId, ref: 'Usert' }

});

CategorySchema.pre('save', function (next) {
  if (this.isNew) {
    jobs.create('CreateLog', {
      user: this.createdBy,
      action: 'created',
      _class: this.constructor.modelName,
      _classId: this._id
    })
    .priority('normal')
    .save();
  }

  if (!this.isNew) {
    jobs.create('CreateLog', {
      user: this.createdBy,
      action: 'update',
      _class: this.constructor.modelName,
      _classId: this._id
    })
    .priority('normal')
    .save();
  }
  next();
});

// CategorySchema.post('remove', function (next) {
//   jobs.create('CreateJob', {
//     user: this.createdBy,
//     action: 'update',
//     _class: this.constructor.modelName,
//     _classId: this._id,
//     description: ''
//   })
//   .priority('normal')
//   .save();
// });

module.exports = mongoose.model('Category', CategorySchema);
