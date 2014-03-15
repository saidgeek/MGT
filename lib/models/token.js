'use strict';

var _makeSalt = function(){
  return crypto.randomBytes(16).toString('base64');
};

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types,
    crypto = require('crypto');


var TokenSchema = new Schema({
  clientToken: { type: String, default: _makeSalt() },
  accessToken: { type: String, default: _makeSalt() },
  salt: { type: String, default: _makeSalt() },
  hashedToken: String,
  description: String,
  enabled: { type: Boolean, default: false},
  createdBy: { type: Types.ObjectId, ref: 'User' },
  createdAt: Date
});

TokenSchema.virtual('token').set(function(enabled){
  this.enabled = enabled;
  this.hashedToken = this.encrypt(this.clientToken+this.accessToken);
}).get(function(){
  return this.hashedToken;
});

TokenSchema.pre('save', function(next){
  next();
});

TokenSchema.virtual('info').get(function(){
  return {
    clientToken: this.clientToken,
    accessToken: this.accessToken
  };
});

TokenSchema.methods = {

  makeSalt: function() {
    return _makeSalt();
  },
  authenticate: function(tokens){
    return this.encrypt(tokens.clientToken+tokens.accessToken) === this.hashedToken;
  },
  encrypt: function(hash){
    var salt = new Buffer(this.salt, 'base64');
    return crypto.pbkdf2Sync(hash, salt, 10000, 64).toString('base64');
  }
};


module.exports = mongoose.model('Token', TokenSchema);