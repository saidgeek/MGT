'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types,
    fs = require('fs'),
    States = require('./STATES'),
    User = mongoose.model('User'),
    moment = require('moment');

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
  state: {},
  message: {},
  sla: { type: String, default: 'GREEN' },
  replications: { type: Number, default: 0 },
  ticket: {
    title: String,
    description: String,
    segments: Array,
    sections: Array,
    category: { type: Types.ObjectId, ref: 'Category' },
    tags: Array,
    attachments: [{
      url: String,
      name: String,
      ext: String,
      size: Number,
      createdBy: { type: Types.ObjectId, ref: 'User' },
      thumbnails: {}
    }]
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

/**==========================================================================**/

SolicitudeSchema.virtual('nextState').set(function (nextState) {
  if (typeof(States[nextState]) !== 'undefined' && States[nextState].after !== null && ~States[nextState].after.indexOf(this.state.type) === -1) {
    this.state = States[nextState].data;
    if (this.state.type === 'QUEUE_VALIDATION_MANAGER') {
      this.duration = null;
    };
  };
});

SolicitudeSchema.virtual('_duration').set(function (_duration) {
  this.duration = _duration * 60000;
  this.startedAt = Date.now();
  this.endedAt = moment(this.startedAt).add('ms', this.duration).toDate();
});

// SolicitudeSchema.path('state').validate(function (value) {
//   return ;
// }, 'Next state invalid');

SolicitudeSchema.pre('save', function(next){
  if (this.isNew) {
  this.code = this._id.toString().substr(0,3).toUpperCase()+this._id.toString().substr(-3,3).toUpperCase();
  this.state = States.queue_validation.data;
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
  // if (this.action === 'update_state') {
  //   var that = this;
  //   for (var i = 0; i < that.involved.length; i++) {
  //     if (~filterRole[that.state].indexOf(that.involved[i].role)) {
  //       // CREACION DE NOTIFICACION
  //       var notifyJob = jobs.create('CreateNotification', {
  //           to: that.involved[i].user,
  //           from: that.state === 'QUEUE_VALIDATION' ? that.createdBy : that.updatedBy,
  //           _type: that.state,
  //           _class: that.constructor.modelName,
  //           _classId: that._id
  //       })
  //       .priority('high')
  //       .save(function (err) {
  //         // GENERAR LOG DE LA ACCION
  //         jobs.create('CreateLog', {
  //           user: that.state === 'QUEUE_VALIDATION' ? that.createdBy : that.updatedBy,
  //           action: that.state === 'QUEUE_VALIDATION' ? 'create' : 'change.state.'+that.state.toLowerCase(),
  //           _class: that.constructor.modelName,
  //           _classId: that._id
  //         })
  //         .priority('high')
  //         .save();
  //         // console.log('notifyJob:', notifyJob);
  //         // ENVIAR EMAIL DE NOTIFICACION
  //         that.sendEmailNotification();
  //       });
  //     };
  //   };
  // }

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
  },
  sendEmailNotification: function () {
    for (var i = 0; i < this.involved.length; i++) {
      var that = this;
      User.findById(this.involved[i].user, function (err, user) {
        if (!err) {

          var dataEmail = {
            QUEUE_VALIDATION: {
              subject: 'Solicitud en espera de validacion',
              _in: ['CLIENT', 'EDITOR'],
              data:{
                name: user.userInfo.name,
                code: that.code,
                url: global.host+'/solicitude/'+that._id
              }
            },
            QUEUE_ACEPT: {
              subject: 'Solicitud aceptada',
              _in: ['CLIENT'],
              data:{
                name: user.userInfo.name,
                code: that.code,
                url: global.host+'/solicitude/'+that._id
              }
            },
            PAUSE: {
              subject: 'Solicitud pausada',
              _in: ['CLIENT'],
              data:{
                name: user.userInfo.name,
                code: that.code,
                url: global.host+'/solicitude/'+that._id,
                comment: ''
              }
            },
            PROCCESS: {
              subject: 'Solicitud en proceso',
              _in: ['CLIENT'],
              data:{
                name: user.userInfo.name,
                code: that.code,
                url: global.host+'/solicitude/'+that._id
              }
            },
            CANCEL: {
              subject: 'Solicitud cancelada',
              _in: ['CLIENT'],
              data:{
                name: user.userInfo.name,
                code: that.code,
                url: global.host+'/solicitude/'+that._id,
                comment: ''
              }
            },
            QUEUE_VALIDATION_CLIENT: {
              subject: 'Solicitud pendiente para revisar',
              _in: ['CLIENT'],
              data:{
                name: user.userInfo.name,
                code: that.code,
                url: global.host+'/solicitude/'+that._id,
              }
            },
            QUEUE_ALLOCATION: {
              subject: 'Solicitud pendiente de asignacion',
              _in: ['CONTENT_MANAGER', 'EDITOR'],
              data:{
                name: user.userInfo.name,
                code: that.code,
                url: global.host+'/solicitude/'+that._id,
              }
            }
          };

          console.log(user.role.toLowerCase()+'_'+that.state.toLowerCase());
          if (~dataEmail[that.state]._in.indexOf(user.role)) {
            jobs.create('sendEmail', {
              to: [{
                email: user.userInfo.email,
                name: user.userInfo.name,
                type: 'to'
              }],
              subject: dataEmail[that.state].subject,
              content: {
                data: dataEmail[that.state].data,
                type: user.role.toLowerCase()+'_'+that.state.toLowerCase()
              }
            })
            .priority('high')
            .save()
          }
        }
      });
    }
  }
};

module.exports = mongoose.model('Solicitude', SolicitudeSchema);
