'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types,
    fs = require('fs'),
    States = require('./STATES'),
    NotifyConf = require('./NOTIFICATIONS'),
    User = mongoose.model('User'),
    moment = require('moment'),
    mongoosastic = require('mongoosastic');

var InvolvedSchema = new Schema({
  user: { type: Types.ObjectId, ref: 'User' },
  role: String,
  isRead: { type: Boolean, default: false },
  readedAt: { type: Date, default: null }
});

var TaskSchema = new Schema({
  check: { type: Boolean, default: false },
  description: String,
  attachments: [{
    id: String,
    name: String,
    link: String
  }],
  createdBy: { type: Types.ObjectId, ref: 'User' },
  createdAt: { type: Date, default: Date.now() }
});

var CommentShema = new Schema({
  content: String,
  involved: [InvolvedSchema],
  attachments: [{
    id: String,
    name: String,
    link: String
  }],
  createdBy: { type: Types.ObjectId, ref: 'User' },
  createdAt: { type: Date, default: Date.now() }
});

var SolicitudeSchema = new Schema({
  code: { type: String, es_indexed: true, es_boost:2.0 },
  priority: { type: String, default: null, es_indexed: true },
  state: {},
  message: {},
  sla: { type: String, default: null },
  slaYellowId: { type: String, default: null },
  slaRedId: { type: String, default: null },
  replications: { type: Number, default: 0 },
  ticket: {
    title: { type: String, es_indexed: true },
    description: { type: String, es_indexed: true },
    segments: [],
    category: { type: Types.ObjectId, ref: 'Category' },
    tags: Array
  },
  involved: [InvolvedSchema],
  tasks: [TaskSchema],
  comments: [
    { type: Types.ObjectId, ref: 'Comment' }
  ],
  attachments: [
    { type: Types.ObjectId, ref: 'Attachment' }
  ],
  // involucrados en la solicitud
  applicant: { type: Types.ObjectId, ref: 'User', default: null }, // solicitante
  editor: { type: Types.ObjectId, ref: 'User', default: null }, //editor
  responsible: { type: Types.ObjectId, ref: 'User', default: null }, // gestor de contenido
  provider: { type: Types.ObjectId, ref: 'User', default: null }, // Proveedor que realizara la solicitud

  startedAt: { type: Date, default: null },
  endedAt: { type: Date, default: null },
  duration: Number,
  pausedAt: { type: Date, default: null },
  createdAt: { type: Date, default: Date.now() },
  createdBy: { type: Types.ObjectId, ref: 'User' },
  updatedAt: { type: Date, default: null },
  updatedBy: { type: Types.ObjectId, ref: 'User' },
  completedAt: { type: Date, default: null },
  archivedAt: {
    ROOT: { type: Date, default: null },
    ADMIN: { type: Date, default: null },
    EDITOR: { type: Date, default: null },
    CLIENT: { type: Date, default: null },
    CONTENT_MANAGER: { type: Date, default: null },
    PROVIDER: { type: Date, default: null }
  }
});


SolicitudeSchema.static('archived', function(id, role, user_id, cb) {

  this.findOne({ _id: id }).exec(function(err, solicitude) {
    if (err) return cb(err);

    solicitude.archivedAt[role] = Date.now();
    solicitude.save(function(err) {
      if (err) return cb(err);
      global.io.sockets.in('solicitude/archived/'+user_id).emit('solicitude.archived', { id: id });
      cb(null, true)
    });
  });

});

/**==========================================================================**/

SolicitudeSchema.virtual('nextState').set(function (nextState) {
  var oldState = this.state;
  if (typeof(States[nextState]) !== 'undefined' && States[nextState].after !== null && States[nextState].after.indexOf(this.state.type) > -1) {
    this.state = States[nextState].data;
    global.io.sockets.in('solicitude/filter/change').emit('solicitude.filter.change', { id: oldState, operation: '-' });
    global.io.sockets.in('solicitude/filter/change').emit('solicitude.filter.change', { id: this.state, operation: '+' });
    global.io.sockets.in('solicitude/change/state').emit('solicitude.change.state', { state: oldState.type.toLowerCase() });
    if (this.state.type === 'QUEUE_VALIDATION_MANAGER') {
      this.duration = null;
    };
    if (oldState.type === 'REJECTED_BY_MANAGER') {
      this.replications = this.replications + 1;
    };

  };
});

SolicitudeSchema.virtual('_duration').set(function (_duration) {
  if (_duration !== null) {
    this.duration = _duration * 60000;
    this.startedAt = Date.now();
    this.endedAt = moment(this.startedAt).add('ms', this.duration).toDate();
  };
});

SolicitudeSchema.static('searching', function(q, user, cb) {

  this.search({ query: q.replace(/\+/g, ' ') }, function(err, solicitudes) {
    if (!err) {

      var type = null,
          _solicitudes = [];

      if (['ADMIN', 'ROOT'].indexOf(user.role) < 0 && user.role === 'CLIENT') {
        type = 'applicant';
      };
      if (['ADMIN', 'ROOT'].indexOf(user.role) < 0 && user.role === 'CONTENT_MANAGER') {
        type = 'responsible';
      };
      if (['ADMIN', 'ROOT'].indexOf(user.role) < 0 && user.role === 'PROVIDER') {
        type = 'provider';
      };
      if (['ADMIN', 'ROOT'].indexOf(user.role) < 0 && user.role === 'EDITOR') {
        type = 'editor';
      };

      if (type !== null) {
        for (var i = 0; i < solicitudes.hits.length; i++) {
          var solicitude = solicitudes.hits[i];
          if (solicitude[type].toString() === user.id.toString()) {
            _solicitudes.push(solicitude);
          };
        };
      } else {
        _solicitudes = solicitudes.hits;
      };

      return cb(null, _solicitudes);

    } else {
      return cb(err);
    };
  });

});

SolicitudeSchema.static('addDuration', function (id, task_duration, cb) {
  if (!id) return cb('No se a enviado una id valida');
  if (task_duration <= 0) return cb('La duracion de la tarea debe ser mayor a 0');

  this.findById(id).exec(function (err, solicitude) {
    if (err) return cb('Solicitud no encontrada');

    // calcular nueva duracion
    var _start = moment().millisecond(solicitude.startedAt)
    var _currentTime = moment().millisecond(Date.now())
    var _diference = _currentTime - _start
    var _newDuration = solicitude.duration - _diference;

    solicitude.duration = solicitude.duration + task_duration;

    solicitude.save(function (err) {
      if (!err) {

        // remover sla actual
        jobs.create('RemoveSLA', {
          solicitudeId: solicitude._id
        })
        .priority('high')
        .save(function () {
          // crear nuevo sla
          jobs.create('CreateSLA', {
            solicitudeId: solicitude._id,
            duration: _newDuration
          })
          .priority('high')
          .save();
          global.io.sockets.in('solicitude/init/sla').emit('solicitude.init.sla', { id: solicitude._id });
          return cb(null);
        });

      };
    });

  });

});

// SolicitudeSchema.path('state').validate(function (value) {
//   return ;
// }, 'Next state invalid');

SolicitudeSchema.pre('save', function(next){
  this.wasNew = this.isNew;
  if (this.isNew) {

    this.code = this._id.toString().substr(0,3).toUpperCase()+this._id.toString().substr(-3,3).toUpperCase();
    this.state = States.queue_validation.data;
    this.createdAt = Date.now();

    // Notificacion en el momento en que se crea la solicitud
    this.createNotification(this.editor, this.applicant, 'Ha enviado nueva solicitud');
    this.sendEmail('editor', ['applicant'], 'solicitude_create');

    jobs.create('CreateLog', {
      user: this.createdBy,
      action: 'create',
      _class: this.constructor.modelName,
      _classId: this._id,
      data: this
    })
    .priority('normal')
    .save();

  } else {
    this.updatedAt = Date.now();
  };

  if (!this.isNew && this.isModified('state')) {

    jobs.create('CreateLog', {
      user: this.updatedBy,
      action: 'change.state.'+this.state.type,
      _class: this.constructor.modelName,
      _classId: this._id,
      data: this
    })
    .priority('normal')
    .save();
  };

  if (!this.isNew && this.isModified('state') && this.state.type === 'CANCELED') {
    this.createNotification(this.applicant, this.editor, 'Ha cancelado la solicitud');
    this.sendEmail('applicant', [], 'solicitude_update');
  };
  if (!this.isNew && this.isModified('state') && this.state.type === 'ASSIGNED_TO_MANAGER') {
    this.createNotification(this.responsible, this.editor, 'Ha asignado una solicitud');
    this.sendEmail('responsible', [], 'solicitude_update');
  };
  if (!this.isNew && this.isModified('state') && this.state.type === 'ASSIGNED_TO_PROVIDER') {
    this.createNotification(this.provider, this.responsible, 'Ha asignado una solicitud');
    this.sendEmail('provider', [], 'solicitude_update');
  };
  if (!this.isNew && this.isModified('state') && this.state.type === 'PROCCESS') {
    this.createNotification(this.responsible, this.provider, 'Solicitud en proceso');
    this.createNotification(this.editor, this.provider, 'Solicitud en proceso');
    this.sendEmail('responsible', ['editor'], 'solicitude_update');
    // nos se si al cliente se le avisara???
  };
  if (!this.isNew && this.isModified('state') && this.state.type === 'PAUSED') {
    this.createNotification(this.provider, this.responsible, 'Solicitud pausada');
    this.sendEmail('provider', [], 'solicitude_update');
  };
  if (!this.isNew && this.isModified('state') && this.state.type === 'REACTIVATED') {
    this.createNotification(this.provider, this.responsible, 'Solicitud reactivada');
    this.sendEmail('provider', [], 'solicitude_update');
  };
  if (!this.isNew && this.isModified('state') && this.state.type === 'QUEUE_VALIDATION_MANAGER') {
    this.createNotification(this.responsible, this.provider, 'Solicitud en espera de revision');
    this.sendEmail('responsible', [], 'solicitude_update');
  };
  if (!this.isNew && this.isModified('state') && this.state.type === 'ACCEPTED_BY_MANAGER') {};
  if (!this.isNew && this.isModified('state') && this.state.type === 'REJECTED_BY_MANAGER') {
    this.createNotification(this.provider, this.responsible, 'Solicitud rechazada');
    this.sendEmail('provider', [], 'solicitude_update');
  };
  if (!this.isNew && this.isModified('state') && this.state.type === 'QUEUE_VALIDATION_CLIENT') {
    this.createNotification(this.applicant, this.responsible, 'Solicitud en espera de revision');
    this.sendEmail('applicant', [], 'solicitude_update');
  };
  if (!this.isNew && this.isModified('state') && this.state.type === 'ACCEPTED_BY_CLIENT') {
    this.createNotification(this.responsible, this.applicant, 'Solicitud aceptada');
    this.sendEmail('responsible', [], 'solicitude_update');
  };
  if (!this.isNew && this.isModified('state') && this.state.type === 'REJECTED_BY_CLIENT') {
    this.createNotification(this.responsible, this.applicant, 'Solicitud rechazada');
    this.sendEmail('responsible', [], 'solicitude_update');
  };
  // ------ nuevos estados
  
  if (!this.isNew && this.isModified('state') && this.state.type == 'QUEUE_VALIDATION_CLIENT_PRO') {
    this.createNotification(this.applicant, this.responsible, 'Solicitud en espera de validación en pro');
    this.sendEmail('applicant', [], 'solicitude_update');
  };

  if (!this.isNew && this.isModified('state') && this.state.type == 'ACCEPTED_BY_CLIENT_PRO') {
    this.createNotification(this.responsible, this.applicant, 'Solicitud aceptada por el cliente en pro');
    this.sendEmail('responsible', [], 'solicitude_update');
  };

  if (!this.isNew && this.isModified('state') && this.state.type == 'REJCETED_BY_CLIENT_PRO') {
    this.createNotification(this.responsible, this.applicant, 'Solicitud rechazada por el cliente en pro');
    this.sendEmail('responsible', [], 'solicitude_update');
  };

  // --------
  if (!this.isNew && this.isModified('state') && this.state.type === 'QUEUE_PUBLISH') {
    this.createNotification(this.provider, this.responsible, 'Solicitud en espera de publicacion');
    this.sendEmail('provider', [], 'solicitude_update');
  };
  if (!this.isNew && this.isModified('state') && this.state.type === 'PUBLISH') {
    this.createNotification(this.responsible, this.provider, 'Solicitud publicada');
    this.sendEmail('responsible', [], 'solicitude_update');
  };
  if (!this.isNew && this.isModified('state') && this.state.type === 'COMPLETED') {
    this.createNotification(this.provider, this.responsible, 'Solicitud completada');
    this.createNotification(this.applicant, this.responsible, 'Solicitud completada');
    this.sendEmail('applicant', ['provider'], 'solicitude_update');
    this.completedAt = Date.now();
  };

  if (!this.isNew && this.isModified('state') && this.state.type === 'PAUSED') {
    this.pausedAt = Date.now();
  };

  if (this.state.type === 'PROCCESS' && this.pausedAt !== null) {
    var _start = moment().millisecond(this.startedAt)
    var _paused = moment().millisecond(this.pausedAt)
    var _diference = _paused - _start
    var _newDuration = this.duration - _diference;

    this.duration = _newDuration + (5*60000);
    this.pausedAt = null;

  };

  if (this.state.type === 'PROCCESS' && this.action !== 'jobs') {

    this.sla = 'GREEN';

    jobs.create('CreateSLA', {
      solicitudeId: this._id,
      duration: this.duration
    })
    .priority('high')
    .save();
    global.io.sockets.in('solicitude/init/sla').emit('solicitude.init.sla', { id: this._id });
  };

  if (!this.isNew && this.isModified('priority')) {
    global.io.sockets.in('solicitude/filter/change').emit('solicitude.filter.change', { id: this.priority, operation: '+' });
  };

  next();
});

SolicitudeSchema.post('save', function () {

  if (this.wasNew) {
    global.io.sockets.in('solicitude/new/'+this.applicant).emit('solicitude.new', { id: this._id });
    if (this.editor.toString() !== this.applicant.toString()) {
      global.io.sockets.in('solicitude/new/'+this.editor).emit('solicitude.new', { id: this._id });
    };
  };


  if (this.state.type === 'PAUSED' && this.action !== 'jobs') {
    jobs.create('RemoveSLA', {
      solicitudeId: this._id
    })
    .priority('high')
    .save();
  };

});

SolicitudeSchema.methods = {

  sendEmail: function(to, cc, type) {

    jobs.create('sendSolicitudeEmail', {
      to: to,
      cc: cc,
      solicitude_id: this._id,
      subject: '[código: '+ this.code +'] ' + this.ticket.title,
      content: {
        data: {
          title: this.ticket.title,
          url: global.host+'/solicitud/'+this._id,
          code: this.code
        },
        type: type
      }
    })
    .priority('high')
    .save();

  },

  createNotification: function(to, from, message) {

    console.log('createNotification:', to, from, message);

    jobs.create('CreateNotification', {
      to: to,
      from: from,
      message: message,
      _class: this.constructor.modelName,
      _classId: this._id
    })
    .priority('high')
    .save();

  },

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

SolicitudeSchema.plugin(mongoosastic, { hydrate: true });

module.exports = mongoose.model('Solicitude', SolicitudeSchema);
