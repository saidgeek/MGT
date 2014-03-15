'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types;

var ToSchema = new Schema({
  user: { type: Types.ObjectId, ref: 'User' },
  isRead: { type: Boolean, default: false },
  readedAt: Date
});

var NotificationSchema = new Schema({
  to: [ToSchema],
  subject: String,
  description: String,
  solicitude: { type: Types.ObjectId, ref: 'Solicitude' },
  createdAt: { type: Date, default: Date.now() }
});

/**
  Static para crear la notificacion
**/

NotificationSchema.methods = {
  readByUser: function(user_id){
    for(var i = 0; i < this.to.length; i++){
      if (this.to[i].user.toString() === user_id.toString()) {
        return this.to.id(this.to[i]._id).isRead;
      };
    };
    return false;
  },
  readed: function(user_id, cb){
    for(var i = 0; i < this.to.length; i++){
      if (this.to[i].user.toString() === user_id.toString()) {
        this.to.id(this.to[i]._id).remove();
        this.to.push({
          user: user_id,
          isRead: true,
          readedAt: Date.now()
        });
      };
    };
    this.save(function(err){
      if (err) {
        return cb(err, null);
      };
    });
    return cb(null, this);
  }
};

module.exports = mongoose.model('Notification', NotificationSchema);