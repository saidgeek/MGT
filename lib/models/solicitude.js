'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types,
    fs = require('fs'),
    States = require('./STATES');

var InvolvedSchema = new Schema({
  user: { type: Types.ObjectId, ref: 'User' },
  _type: String,
  read: { type: Boolean, default: false },
  readedAt: Date
});

var TaskSchema = new Schema({
  description: String,
  createdBy: { type: Types.ObjectId, ref: 'User' },
  createdAt: { type: Date, default: Date.now() }
});

var CommentShema = new Schema({
  content: String,
  involved: [InvolvedSchema],
  attachments: [{ type: Types.ObjectId, ref: 'Attachment' }],
  createdBy: { type: Types.ObjectId, ref: 'User' },
  createdAt: { type: Date, default: Date.now() }
});

var SolicitudeSchema = new Schema({
  priority: String,
  state: { type: String, default: States.default },
  sla: { type: String, default: 'GREEN' },
  replications: { type: Number, default: 0 },
  ticket: {
    title: String,
    description: String,
    segmants: Array,
    sections: Array,
    attachments: [{ type: Types.ObjectId, ref: 'Attachment' }]
  },
  involved: [InvolvedSchema],
  Tasks: [TaskSchema],
  comments: [CommentShema],
  startedAt: Date,
  endedAt: Date,
  createdAt: { type: Date, default: Date.now() },
  createdBy: { type: Types.ObjectId, ref: 'User' }
});

SolicitudeSchema.pre('save', function(next){
  if (this.isNew) {
  /**
    Metodos para crear las notificaciones y reportes
  **/
  };
  next();
});

SolicitudeSchema.methods = {
  changeToState: function(nextState, cb){
    if (~States[nextState].after.indexOf(this.state)) {
      this.state = nextState.toUpperCase();
      var that = this;
      this.save(function(err){
        if (err) {
          return cb(err, null);
        } else {
          // agregar metodo de reporte
          return cb(null, that);
        };
      });
    }else{

    };
  }
};

module.exports = mongoose.model('Solicitude', SolicitudeSchema);
