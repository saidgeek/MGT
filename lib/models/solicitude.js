'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types,
    fs = require('fs'),

var States = fs.readFile('/STATES.json', function(err, data){
  if (err) return 'no data';
  return JSON.parse(data);
});

InvolvedSchema = new Schema({
  user: { type: Types.ObjectId, ref: 'User' },
  _type: String,
  read: { type: Boolean, default: false },
  readedAt: Date
});

TaskSchema = new Schema({
  description: String,
  createdBy: { type: Types.ObjectId, ref: 'User' },
  createdAt: { type: Date, default: Date.now() }
});

CommentShema = new Schema({
  content: String,
  involved: [InvolvedSchema],
  attachments: [{ type: Types.ObjectId, ref: 'Attachment' }],
  createdBy: { type: Types.ObjectId, ref: 'User' },
  createdAt: { type: Date, default: Date.now() }
});

TicketSchema = new Schema({
  title: String,
  description: String,
  segmants: [],
  sections: [],
  attachments: [{ type: Types.ObjectId, ref: 'Attachment' }]
});

SolicitudeSchema = new Schema({
  priority: String,
  state: { type: String, default: States.default },
  sla: { type: String, default: 'GREEN' },
  replications: { type: Number, default: 0 },
  ticket: TicketSchema,
  involved: [InvolvedSchema],
  Tasks: [TaskSchema],
  comments: [CommentShema]
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
