'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types,
    fs = require('fs'),
    States = require('./STATES'),
    NotifyConf = require('./NOTIFICATIONS'),
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
  attachments: [{
      url: String,
      name: String,
      ext: String,
      size: Number,
      createdBy: { type: Types.ObjectId, ref: 'User' },
      thumbnails: {}
    }],
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
  responsible: { type: Types.ObjectId, ref: 'User' },
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

SolicitudeSchema.post('save', function () {

  var that = this;
  var conf = NotifyConf[this.state.type];

  console.log('this.state.type:', this.state.type, 'conf:', conf);
  for (var i = 0; i < that.involved.length; i++) {

      User.findById(that.involved[i].user, function (err, user) {
        console.log('err:', err);
        if (!err) {

          console.log(i, 'user.role:', user.role, 'conf[user.role]:', conf[user.role]);

          var _role = user.role;
          if (['ADMIN', 'ROOT'].indexOf(_role) > -1) {
            _role = 'CLIENT';
          };

          if (typeof(conf[_role]) !== 'undefined') {

            console.log('this.involved[i]:', _role);
            console.log('conf[_role]:', conf[_role]);

            if (conf[_role].action.indexOf('notification') > -1) {

              jobs.create('CreateNotification', {
                to: user._id,
                from: that.state.type === 'QUEUE_VALIDATION' ? that.createdBy : that.updatedBy,
                message: conf[_role]['notification'],
                _class: that.constructor.modelName,
                _classId: that._id
              })
              .priority('high')
              .save();

            };
            
            if (conf[_role].action.indexOf('email') > -1) {

              var _data = {};
              if (conf[_role].email.data.indexOf('name') > -1) _data['name'] = user.userInfo.name;
              if (conf[_role].email.data.indexOf('code') > -1) _data['code'] = that.code;
              if (conf[_role].email.data.indexOf('url') > -1) _data['url'] = global.host+'/solicitude/'+that._id;
              if (conf[_role].email.data.indexOf('comment') > -1) _data['comment'] = that.message[that.state.type.toLowerCase()].content;

              jobs.create('sendEmail', {
                to: [{
                  email: user.userInfo.email,
                  name: user.userInfo.name,
                  type: 'to'
                }],
                subject: conf[_role].subject,
                content: {
                  data: _data,
                  type: _role.toLowerCase()+'_'+that.state[_role].toLowerCase()
                }
              })
              .priority('high')
              .save()

            };

            jobs.create('CreateLog', {
              user: that.state.type === 'QUEUE_VALIDATION' ? that.createdBy : that.updatedBy,
              action: that.state.type === 'QUEUE_VALIDATION' ? 'create' : 'change.state.'+that.state.type.toLowerCase(),
              _class: that.constructor.modelName,
              _classId: that._id
            })
            .priority('high')
            .save();

          };
        };
      });

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
