'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types;

var NotificationSchema = new Schema({
  to: { type: Types.ObjectId, ref: 'User' },
  from: { type: Types.ObjectId, ref: 'User' },
  message: String,
  _class: String,
  _classId: String,
  isRead: { type: Boolean, default: false },
  readedAt: { type: Date, default: null },
  createdAt: { type: Date, default: Date.now() }
});

NotificationSchema.virtual('_to').get(function () {
  mongoose.model('User').findById(this.to, function (err, user) {
    if (!err) {
      return user;
    }
  });
});

NotificationSchema.virtual('referer').get(function () {
  mongoose.model(this._class).findById(this._classId, function (err, data) {
    if (!err) {
      return data;
    }
  });
});

NotificationSchema.virtual('info').get(function () {
  return {
    _id: this._id,
    to: this._to,
    description: this.description,
    referer: this.referer,
    createdAt: this.createdAt
  };
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
