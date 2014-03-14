'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = mongoose.Types;

ToSchema = new Schema({
  user: { type: Types.ObjectId, ref: 'User' },
  isRead: { type: Boolean, default: false },
  readedAt: Date
});

NotificationSchema = new Schema({
  to: [ToSchema],
  subject: String,
  description: String,
  solicitude: { type: Types.ObjectId, ref: 'Solicitude' },
  createdAt: { type: Date, default: Date.now() }
});

/**
  Static para crear la notificacion
**/

NotificationSchema.methos = {
  read: function(user_id, cb){
    for(var item in this.to){
      if (item.user.toString() === user_id) {
        this.to.id(item._id).remove();
        this.to.push({
          user: item.user,
          isRead: true,
          readedAt: Date.now()
        });
      };
    this.save(function(err){
      if (err) {
        return cb(err, null);
      } else {
        return cb(null, this);
      };
    });
    }
  }
};

module.exports = mongoose.model('Notification', NotificationSchema);