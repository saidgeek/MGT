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
  };
});

// SolicitudeSchema.path('state').validate(function (value) {
//   return ;
// }, 'Next state invalid');

SolicitudeSchema.pre('save', function(next){
  if (this.isNew) {
  this.code = this._id.toString().substr(0,6).toUpperCase();
  /**
    Metodos para crear las notificaciones y reportes
  **/
  };
  next();
});

var filterRole = {
  QUEUE_VALIDATION: ['EDITOR'],
  QUEUE_ALLOCATION: ['CONTENT_MANAGER'],
  QUEUE_PROVIDER: ['PROVIDER']
};

SolicitudeSchema.post('save', function () {

  // REFACTORIZAR :)
  var that = this;
  for (var i = 0; i < that.involved.length; i++) {
    if (~filterRole[that.state].indexOf(that.involved[i].role)) {
      // CREACION DE NOTIFICACION
      var notifyJob = jobs.create('CreateNotification', {
          to: that.involved[i].user,
          from: that.state === 'QUEUE_VALIDATION' ? that.createdBy : that.updatedBy,
          _type: that.state,
          _class: that.constructor.modelName,
          _classId: that._id
      })
      .priority('high')
      .save(function (err) {
        // generar log de la accion
        jobs.create('CreateLog', {
          user: that.state === 'QUEUE_VALIDATION' ? that.createdBy : that.updatedBy,
          action: that.state === 'QUEUE_VALIDATION' ? 'create' : 'change.state.'+that.state.toLowerCase(),
          _class: that.constructor.modelName,
          _classId: that._id
        })
        .priority('high')
        .save();
        // console.log('notifyJob:', notifyJob);
      });

      // ENVIAR EMAIL DE NOTIFICACION
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
