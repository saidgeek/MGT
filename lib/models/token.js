'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types,
    crypto = require('crypto');


var TokenSchema = new Schema({
  clientToken: String,
  accessToken: String,
  salt: String,
  token: String,
  createdBy: { type: Types.ObjectId, ref: 'User' },
  createdAt: { type: Date, default: Date.now() }
});

TokenSchema.pre('save', function(next){

  if (this.isNew) {
    this.clientToken = this.makeKey();
    this.accessToken = this.makeKey();
    this.salt = this.makeSalt();
    this.token = crypto.pbkdf2Sync(this.clientToken+this.accessToken, this.salt, 10000, 64).toString('base64');
  };
  next();

});

TokenSchema.virtual('tokenInfo').get(function(){
  return {
    client: this.clientToken,
    access: this.accessToken
  };
});

TokenSchema.methods = {

  makeSalt: function() {
    return crypto.randomBytes(16).toString('base64');
  },
  makeKey: function(){
    var salt = new Buffer(this.makeSalt(), 'base64');
    return crypto.pbkdf2Sync(Date.now(), salt, 10000, 64).toString('base64');
  },
  authenticateToken: function($clientToken, $accessToken){
    var hash = crypto.pbkdf2Sync($clientToken+$accessToken, this.salt, 10000, 64).toString('base64');
    if (this.token === hash) return next();
  }
};

try{
  module.exports = mongoose.model('Token', TokenSchema);
} catch(err) {

};





