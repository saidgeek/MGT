'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types,
    Attachment = mongoose.model('Attachment'),
    Task = mongoose.model('Task'),
    Solicitude = mongoose.model('Solicitude');


var CommentSchema = new Schema({
  type: { type: String, default: 'solicitude' }, // tipos: solicitude, solicitude.[...], tasks
  to: { type: Types.ObjectId, ref: 'User', default: null },
  solicitude: { type: Types.ObjectId, ref: 'Solicitude', default: null },
  task: { type: Types.ObjectId, ref: 'Task', default: null },
  message: { type: String, default: null },
  attachments: [
    { type: Types.ObjectId, ref: 'Attachment', default: null }
  ],
  createdBy: { type: Types.ObjectId, ref: 'User', default: null },
  createdAt: { type: Date, default: null }
});

CommentSchema.static('add', function(type, to, solicitude_id, message, attachments, createdBy) {

  var comment = new this();

  comment.type = type;
  comment.to = to;
  comment.solicitude = solicitude_id;
  comment.message = message;
  comment.createdBy = createdBy;

  comment.save(function(err) {
    if (!err) {

      if (attachments.length > 0) {
        Attachment.add({ name: 'Comment', id: comment._id }, solicitude_id, attachments, req.params.client_id, function(err, atts) {
          if (!err) {
            comment.attachments = atts;
            commet.save();
          };
        });
      };

    };
  });

});

CommentSchema.pre('save', function(next) {
  this.wasNew = this.isNew;

  if (this.isNew) {
    this.createdAt = Date.now();
  };


  next();
});

CommentSchema.post('save', function() {
  if (this.wasNew) {
    // EMIT SOCKET

    if (this.type === 'Task' && this.task !== null) {
      Task.addComment(this.task, this._id);
      global.io.sockets.in('task/new/comment').emit('task.new.comment', { task: this.task, comment: this._id });
    } else {
      global.io.sockets.in('solicitude/new/comment').emit('solicitude.new.comment', { solicitude: this.solicitude, comment: this._id });
    };

    if (typeof(this.to) !== 'undefined' && this.to !== null) {

      var that = this;

      Solicitude.findById(this.solicitude)
        .select('applicant editor responsible provider')
        .populate('applicant')
        .populate('editor')
        .populate('responsible')
        .populate('provider')
        .exec(function(err, solicitude) {

          if (that.type === 'Solicitude.pm') {

            if (that.createdBy.toString() !== solicitude.applicant._id.toString()) {
              jobs.create('CreateNotification', {
                to: solicitude.applicant._id,
                from: that.createdBy,
                message: 'Te a dejado un comentario',
                _class: 'Solicitude',
                _classId: that.solicitude
              })
              .priority('high')
              .save()
            }

            if (that.createdBy.toString() !== solicitude.editor._id.toString()) {
              jobs.create('CreateNotification', {
                to: solicitude.editor._id,
                from: that.createdBy,
                message: 'Te a dejado un comentario',
                _class: 'Solicitude',
                _classId: that.solicitude
              })
              .priority('high')
              .save()
            }

            if (typeof(solicitude.responsible) !== 'undefined' && solicitude.responsible !== null && that.createdBy.toString() !== solicitude.responsible._id.toString()) {
              jobs.create('CreateNotification', {
                to: solicitude.responsible._id,
                from: that.createdBy,
                message: 'Te a dejado un comentario',
                _class: 'Solicitude',
                _classId: that.solicitude
              })
              .priority('high')
              .save()
            }

          };

          if (that.type === 'Solicitude.internal') {

            if (that.createdBy.toString() !== solicitude.editor._id.toString()) {
              jobs.create('CreateNotification', {
                to: solicitude.editor._id,
                from: that.createdBy,
                message: 'Te a dejado un comentario',
                _class: 'Solicitude',
                _classId: that.solicitude
              })
              .priority('high')
              .save()
            }

            if (typeof(solicitude.responsible) !== 'undefined' && solicitude.responsible !== null &&  that.createdBy.toString() !== solicitude.responsible._id.toString()) {
              jobs.create('CreateNotification', {
                to: solicitude.responsible._id,
                from: that.createdBy,
                message: 'Te a dejado un comentario',
                _class: 'Solicitude',
                _classId: that.solicitude
              })
              .priority('high')
              .save()
            }

          };   

          if (that.type === 'Solicitude.provider') {

            if (typeof(solicitude.provider) !== 'undefined' && solicitude.provider !== null && that.createdBy.toString() !== solicitude.provider._id.toString()) {
              jobs.create('CreateNotification', {
                to: solicitude.provider._id,
                from: that.createdBy,
                message: 'Te a dejado un comentario',
                _class: 'Solicitude',
                _classId: that.solicitude
              })
              .priority('high')
              .save()
            }

            if (that.createdBy.toString() !== solicitude.editor._id.toString()) {
              jobs.create('CreateNotification', {
                to: solicitude.editor._id,
                from: that.createdBy,
                message: 'Te a dejado un comentario',
                _class: 'Solicitude',
                _classId: that.solicitude
              })
              .priority('high')
              .save()
            }

            if (typeof(solicitude.responsible) !== 'undefined' && solicitude.responsible !== null && that.createdBy.toString() !== solicitude.responsible._id.toString()) {
              jobs.create('CreateNotification', {
                to: solicitude.responsible._id,
                from: that.createdBy,
                message: 'Te a dejado un comentario',
                _class: 'Solicitude',
                _classId: that.solicitude
              })
              .priority('high')
              .save()
            }

          };       

        });

    };

  };
});

module.exports = mongoose.model('Comment', CommentSchema);
