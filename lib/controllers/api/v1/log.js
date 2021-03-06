'use strict';

var mongoose = require('mongoose'),
    Log = mongoose.model('Log'),
    Solicitude = mongoose.model('Solicitude'), 
    User = mongoose.model('User'),
    Category = mongoose.model('Category'),
    excel = require('excel-export'),
    moment = require('moment'),
    sync = require('sync');

exports.excel = function(req, res) {

  var conf = {};
  var rows = [];
  // conf.stylesXmlFile = './lib/config/styles.xml';

    // cols: usuario, rol, solicitud, accion, fecha

  conf.cols = [

    {
      caption: 'Código',
      type: 'string'
    },

    {
      caption: 'Solicitud',
      type: 'string'
    },
    {
      caption: 'Accion',
      type: 'string'
    }

  ];

  Log.find({ user: req.params.user_id })
    .populate('user')
    .populate({
      path: '_classId',
      model: 'Solicitude'
    })
    .exec(function(err, logs) {
      if (!err) {

        for (var i in logs) {
          
          if (logs[i]._classId) {
            rows.push([logs[i]._classId.code, logs[i]._classId.ticket.title, logs[i].action]);
          };

        };

        conf.rows = rows;
        // var result = excel.execute(conf);

        // res.setHeader('Content-Type', 'application/vnd.openxmlformats');
        // res.setHeader("Content-Disposition", "attachment; filename=" + req.params.user_id + "_report.xlsx");
        // res.end(result, 'binary');

        res.set({
          'Content-Type': 'application/octet-stream',
          'Content-disposition': "attachment; filename=" + req.params.user_id + "_report.xlsx"
        });
        var returnVar = new Buffer(excel.execute(conf), 'binary'); // cols & rows are utf-8
        res.send(returnVar);

      };
    });

};

exports.csv =  function(req, res) {

  var rows = [];
  var filename = req.params.user_id + "_report.csv";
  var columns = [
    'Cliente','Fecha de creacion','Responsable','Código','Estado','Titulo','Fecha de inicio','Acción','Fecha cambio de acción','Prioridad','Categoría','Proveedor','Fecha de fin','SLA','Tiempo total'
  ];

  if (!req.params.user_id) return res.json(403);

  Log.find({ user: req.params.user_id })
    .where({ _class: 'Solicitude' })
    .populate('user')
    .sort('createdAt')
    .exec(function(err, logs) {
      if (err) return res.json(400, err);

      for (var i = 0; i < logs.length; i++) {
        if (typeof(logs[i].data) !== 'undefined') {
          var log = logs[i];

          log.getRowReport(log.user.role, function(err, row) {
            if (!err) {

              rows.push(row);
              if (rows.length == logs.length) {
                res.csv( rows, filename );
              };

            };
          });

        };
      };

    });

};

exports._csv = function(req, res) {

  var rows = [];
  var filename = req.params.user_id + "_report.csv";
  var columns = [
    'Usuario', 
    'Accion', 
    'Codigo', 
    'Titulo', 
    'Estado', 
    'Prioridad', 
    'Categoría', 
    'Tags', 
    'SLA',
    'Fecha Solicitud', 
    'Fecha inicio',
    'Fecha fin'];

  Log.find({ user: req.params.user_id })
    .where({ _class: 'Solicitude' })
    .populate('user')
    .exec(function(err, logs) {
      if (!err) {

        for (var i in logs) {

          if (typeof(logs[i].data) !== 'undefined') {

            rows.push({
              'Usuario': logs[i].user.profile.firstName+' '+logs[i].user.profile.lastName+' ('+logs[i].user.role+')', 
              'Accion': logs[i].action,
              'Codigo': logs[i].data.code,
              'Titulo': logs[i].data.ticket.title, 
              'Estado': logs[i].data.state[logs[i].user.role], 
              'Prioridad': logs[i].data.priority || '', 
              'Categoría': logs[i].data.ticket.category || '', 
              'Tags': logs[i].data.ticket.tags.join(',').toString() || '', 
              'SLA': logs[i].data.sla || '',
              'Fecha Solicitud': logs[i].data.createdAt, 
              'Fecha inicio': logs[i].data.startedAt,
              'Fecha fin': logs[i].data.endedAt,

            });

          };

        };

        res.csv( rows, filename );

      };
    });

};