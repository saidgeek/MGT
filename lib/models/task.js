'use strict';

var mongoose = require('mongoose'),
    Solicitude = mongoose.model('Solicitude'),
    Schema = mongoose.Schema,
    Types = Schema.Types;


var TaskSchema = new Schema({
  content: { type: String, default: null },
  duration: { type: Number, default: null },
  isComplete: { type: Boolean, default: false },
  solicitude: { type: Types.ObjectId, ref: 'Solicitude' },
  attachments: [
    { type: Types.ObjectId, ref: 'Attachment' }
  ],
  comments: [
    { type: Types.ObjectId, ref: 'Comment' }
  ],
  completedAt: { type: Date, default: null },
  createdBy: { type: Types.ObjectId, ref: 'User' },
  createdAt: { type: Date, default: null }
});

TaskSchema.static('addComment', function(id, comment_id) {

  this.findById(id, function(err, task) {
    if (!err) {
      task.comments.push( comment_id );
      task.save();
    };
  });

});

TaskSchema.pre('save', function(next) {
  this.wasNew = this.isNew;

  if (this.isNew) {
    this.createdAt = Date.now();
  };

  next();
});

TaskSchema.post('save', function() {

  if (this.wasNew) {
    global.io.sockets.in('solicitude/new/task').emit('solicitude.new.task', { solicitude: this.solicitude, task: this._id });
  };

  if (this.duration !== null) {
    console.log('la tarea tiene una duracion nueva!!');
    Solicitude.addDuration(this.solicitude, this.duration, function (err) {
      if (err) return console.log(err);
      console.log('Se a agregado la duraciona la solicitud!!');
    });
  };

});

module.exports = mongoose.model('Task', TaskSchema);
