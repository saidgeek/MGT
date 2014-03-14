'use strict'; 

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types;

var CategorySchema = new Schema({
  name: String,
  description: String,
  createdBy: { type: Types.ObjectId, ref: 'Usert' },
  createdAt: { type: Date, default: Date.now() }
});

module.exports = mongoose.model('Category', CategorySchema);