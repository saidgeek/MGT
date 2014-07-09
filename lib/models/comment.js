'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types,
    Attachment = mongoose.model('Attachment'),
    Task = mongoose.model('Task');


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
      global.io.sockets.in('solicitude/new/comment').emit('solicitude.new.comment', { comment: this });
    };

  };
});

module.exports = mongoose.model('Comment', CommentSchema);
