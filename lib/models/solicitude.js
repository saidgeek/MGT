'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types,
    fs = require('fs'),
    States = require('./STATES');

var InvolvedSchema = new Schema({
  user: { type: Types.ObjectId, ref: 'User' },
  role: String,
  isRead: { type: Boolean, default: false },
  readedAt: { type: Date, default: null }
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
  code: String,
  priority: String,
  state: { type: String, default: States.default },
  sla: { type: String, default: 'GREEN' },
  replications: { type: Number, default: 0 },
  ticket: {
    title: String,
    description: String,
    segments: Array,
    sections: Array,
    category: { type: Types.ObjectId, ref: 'Category' },
    tags: Array,
    attachments: Array
  },
  involved: [InvolvedSchema],
  tasks: [TaskSchema],
  comments: [CommentShema],
  responible: { type: Types.ObjectId, ref: 'User' },
  provider: { type: Types.ObjectId, ref: 'User' },
  startedAt: Date,
  endedAt: Date,
  duration: Number,
  createdAt: { type: Date, default: Date.now() },
  createdBy: { type: Types.ObjectId, ref: 'User' },
  updatedBy: { type: Types.ObjectId, ref: 'User' }
});

SolicitudeSchema.virtual('nextState').set(function (nextState) {
  if (typeof(States[nextState]) !== 'undefined' && States[nextState].after !== null && ~States[nextState].after.indexOf(this.state) === -1) {
    this.state = nextState.toUpperCase();
  }else{
    // GENERAR EXEPTION
    // buacar forma de generar error para mongo
    throw new exception('Incorrect next State', 'The next state is incorrect.');
  };
});

SolicitudeSchema.pre('save', function(next){
  if (this.isNew) {
  this.code = this._id.toString().substr(0,6).toUpperCase();
  /**
    Metodos para crear las notificaciones y reportes
  **/
  };
  next();
});

SolicitudeSchema.post('save', function () {

  // REFACTORIZAR :)

  if (this.state === 'QUEUE_VALIDATION') {
    for (var i = 0; i < this.involved.length; i++) {
      if (this.involved[i].role === 'EDITOR') {
        // CREACION DE NOTIFICACION
        jobs.create('CreateNotification', {
            to: this.involved[i].user,
            from: this.createdBy,
            _type: this.state,
            _class: this.constructor.modelName,
            _classId: this._id
        })
        .priority('high')
        .save();

        // ENVIAR EMAIL DE NOTIFICACION
      };
    };
  };

  if (this.state === 'QUEUE_ALLOCATION') {
    for (var i = 0; i < this.involved.length; i++) {
      if (this.involved[i].role === 'CONTENT_MANAGER') {
        // CREACION DE NOTIFICACION
        jobs.create('CreateNotification', {
            to: this.involved[i].user,
            from: this.updatedBy,
            _type: this.state,
            _class: this.constructor.modelName,
            _classId: this._id
        })
        .priority('high')
        .save();

        // ENVIAR EMAIL DE NOTIFICACION
      };
    };
  }

  if (this.state === 'QUEUE_PROVIDER') {
    for (var i = 0; i < this.involved.length; i++) {
      if (this.involved[i].role === 'PROVIDER') {
        // CREACION DE NOTIFICACION
        jobs.create('CreateNotification', {
            to: this.involved[i].user,
            from: this.updatedBy,
            _type: this.state,
            _class: this.constructor.modelName,
            _classId: this._id
        })
        .priority('high')
        .save();

        // ENVIAR EMAIL DE NOTIFICACION
      };
    };
  };
});

SolicitudeSchema.methods = {
  changeToState: function(nextState, cb){
    if (States[nextState].after !== null && ~States[nextState].after.indexOf(this.state) === -1) {
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
      return cb('Next state is not valid', null);
    };
  }
};

module.exports = mongoose.model('Solicitude', SolicitudeSchema);
