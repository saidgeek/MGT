'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types;

var ReportSchema = new Schema({
  user: { type: Types.ObjectId, ref: 'User' },
  _typeId: String,
  _type: String,
  action: String,
  description: String,
  createdAt: { type: Date, default: Date.now() }
});

/**
  Hay que re-pensar el metodo de creacion de el reporte
**/

module.exports = mongoose.model('Report', ReportSchema);