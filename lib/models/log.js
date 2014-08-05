'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types,
    Solicitude = mongoose.model('Solicitude'),
    moment = require('moment');

var LogSchema = new Schema({
  user: { type: Types.ObjectId, ref: 'User' },
  _classId: String,
  _class: String,
  action: String,
  data: {},
  createdAt: { type: Date, default: Date.now() }
});

/**
  Hay que re-pensar el metodo de creacion de el reporte
**/

var translate = function(action) {

  var values = {

    ASSIGNED_TO_MANAGER: 'asignado a gestor',
    ASSIGNED_TO_PROVIDER: 'asignado a proveedor',
    QUEUE_VALIDATION_MANAGER: 'espera validacion gestor',
    ACCEPTED_BY_MANAGER: 'aceptada por gestor',
    REJECTED_BY_MANAGER: 'rechazada por gestor',
    QUEUE_VALIDATION_CLIENT: 'espera validacion cliente',
    ACCEPTED_BY_CLIENT: 'aceptada por cliente',
    REJECTED_BY_CLIENT: 'rechazada por cliente',
    QUEUE_VALIDATION: 'espera validacion',
    CANCELED: 'cancelada',
    ACCEPTED: 'aceptada',
    ASSIGNED: 'asignada',
    QUEUE_PROVIDER: 'espera de proveedor',
    PROCCESS: 'en proceso',
    PAUSED: 'pausada',
    FOR_VALIDATION: 'por validacion',
    QUEUE_CHANGE: 'espera cambios',
    FOR_CHANGE: 'por cambios',
    REJECTED: 'rechazada',
    QUEUE_PUBLISH: 'espera publicación',
    PUBLISH: 'publicada',
    COMPLETED: 'completada',
    REACTIVATED: 'reactivado',
    create: 'Creación',
    update: 'Actualización',
    INCIDENCE: 'Incidencia',
    HIGH: 'Alta',
    AVERAGE: 'Media',
    DECLINE: 'Baja'

  };

  var keys = [];

  if (typeof(action) !== 'undefined' && action !== null && action !== '') {
    keys = action.split('.');  
  };
  var value = '';

  if (keys.length === 1) {
    value = values[keys[0]]
  } else {
    if (keys.length === 3 && keys[0] === 'change' && keys[1] === 'state') {
      value = 'Estado cambiado a '+values[keys[2]];
    };
  };

  return value;

};

LogSchema.methods = {
  getRowReport: function(role, cb) {

    var that = this;

    Solicitude.findById(this.data._id.toString())
      .populate('applicant')
      .populate('editor')
      .populate('responsible')
      .populate('provider')
      .populate('ticket.category')
      .exec(function(err, s) {
        if (!err && typeof(s) !== 'undefined') {

          var _applicant = '';
          var _editor = '';
          var _responsible = '';
          var _provider = '';
          var _category = '';
          var _created_at = '';
          var _started_at = '';
          var _ended_at = '';
          var _updated_at = '';
          var _sla = '';
          var _total_time = '';

          if (typeof(s.applicant) !== 'undefined' && s.applicant !== null) {
            _applicant = s.applicant.profile.firstName+' '+s.applicant.profile.lastName;
          };

          if (typeof(s.editor) !== 'undefined' && s.editor !== null) {
            _editor = s.editor.profile.firstName+' '+s.editor.profile.lastName;
          };

          if (typeof(s.responsible) !== 'undefined' && s.responsible !== null) {
            _responsible = s.responsible.profile.firstName+' '+s.responsible.profile.lastName;
          };

          if (typeof(s.provider) !== 'undefined' && s.provider !== null) {
            _provider = s.provider.profile.firstName+' '+s.provider.profile.lastName;
          };


          if (typeof(that.data.ticket.category) !== 'undefined' && that.data.ticket.category !== null) {
            _category = s.ticket.category.name;
          };

          _created_at = moment(s.createdAt).format('DD/MM/YYYY h:mm:ss a');

          if (typeof(that.data.startedAt) !== 'undefined' && that.data.startedAt !== null) {
            _started_at = moment(s.startedAt).format('DD/MM/YYYY h:mm:ss a');
          };
          
          _updated_at = moment(that.createdAt).format('DD/MM/YYYY h:mm:ss a');

          if (typeof(that.data.endedAt) !== 'undefined' && that.data.endedAt !== null) {
            _ended_at = moment(s.endedAt).format('DD/MM/YYYY h:mm:ss a');
          };

          if (typeof(that.data.completedAt) !== 'undefined' && that.data.completedAt !== null && typeof(that.data.endedAt) !== 'undefined' && that.data.endedAt !== null) {
            var diff = moment(s.completedAt).diff(s.startedAt);
            console.log('_sla:', diff);
            _sla = Math.floor(diff / 60000)+'min';
          };

          if (typeof(that.data.completedAt) !== 'undefined' && that.data.completedAt !== null) {
            var diff = moment(s.completedAt).diff(s.createdAt);
            console.log('_total_time:', diff);
            _total_time = Math.floor(diff / 60000)+'min';
          };

          cb(null, {
            'Cliente': _applicant,
            'Fecha de creacion': _created_at,
            'Responsable': _responsible,
            'Código': s.code,
            'Estado': translate(that.data.state[role]),
            'Titulo': s.ticket.title,
            'Fecha de inicio': _started_at,
            'Acción': translate(that.action),
            'Fecha cambio de acción': _updated_at,
            'Prioridad': translate(s.priority),
            'Categoría': _category,
            'Proveedor': _provider,
            'Fecha de fin': _ended_at,
            'SLA': _sla,
            'Tiempo total': _total_time

          });

        };
      });

  }
};

module.exports = mongoose.model('Log', LogSchema);
