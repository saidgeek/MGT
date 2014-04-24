'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types;

var LogSchema = new Schema({
  user: { type: Types.ObjectId, ref: 'User' },
  _classId: String,
  _class: String,
  action: String,
  createdAt: { type: Date, default: Date.now() }
});

/**
  Hay que re-pensar el metodo de creacion de el reporte
**/

module.exports = mongoose.model('Log', LogSchema);
