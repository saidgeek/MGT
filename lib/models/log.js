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

LogSchema.static('getRowReport', function(id, action, cb) {

  

});

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
            'Estado': that.data.state[role],
            'Titulo': s.ticket.title,
            'Fecha de inicio': _started_at,
            'Acción': that.action,
            'Fecha cambio de acción': _updated_at,
            'Prioridad': s.priority || '',
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
