'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Types = Schema.Types,
    crypto = require('crypto'),
    Email = mongoose.model('Email'),
    moment = require('moment'),
    permissions = require('./PERMISSIONS');

var authTypes = ['github', 'twitter', 'facebook', 'google'];

/**
 * User Schema
 */
var UserSchema = new Schema({
  email: String,
  role: { type: String, default: 'user' },
  tempPassword: String,
  hashedPassword: String,
  oldHashedPassword: String,
  provider: String,
  salt: String,
  profile: {
    avatar: String,
    firstName: String,
    lastName: String,
    description: String,
    phoneNumber: String,
    celNumber: String,
    company: String
  },
  access: {},
  confirmAt: { type: Date, default: null },
  changePasswordAt: { type: Date, default: null },
  _blocked: { type: Boolean, default: false },
  sendEmailNewUser: { type: Boolean, default: false },
  createdAt: { type: Date, default: Date.now() },
  updatedBy: { type: Types.ObjectId, ref: UserSchema },
  createdBy: { type: Types.ObjectId, ref: UserSchema }
});

/**
 * Virtuals
 */
UserSchema.virtual('password').set(function(password) {
    this._password = password;
    this.salt = this.makeSalt();
    this.hashedPassword = this.encryptPassword(password);
  })
  .get(function() {
    return this._password;
  });

// Basic info to identify the current authenticated user in the app
UserSchema.virtual('userInfo').get(function() {
    return {
      'id': this._id,
      'avatar': this.profile.avatar,
      'name': this.profile.firstName+' '+this.profile.lastName,
      'email': this.email,
      'role': this.role,
      'permissions': permissions[this.role],
      'access': this.access,
      'confirmAt': this.confirmAt
    };
  });

UserSchema.virtual('newUser').get(function() {
  return {
    to: [{
      email: this.userInfo.email,
      name: this.userInfo.name,
      type: 'to'
    }],
    subject: 'Nuevo usuario',
    content: {
      data:{
        name: this.userInfo.name,
        role: this.userInfo.role,
        email: this.userInfo.email,
        password: this.tempPassword,
        link_login: global.host+'/login'
      },
      type: 'newUser'
    }
  };
});

UserSchema.virtual('recoveryEmail').get(function() {
  return {
    to: [{
      email: this.userInfo.email,
      name: this.userInfo.name,
      type: 'to'
    }],
    subject: 'Recuperación de contraseña.',
    content: {
      data:{
        name: this.userInfo.name,
        password: this.tempPassword,
        link_login: global.host+'/login'
      },
      type: 'recoveryPassword'
    }
  };
});

UserSchema.virtual('changePassword').set(function(changePassword) {
  if (this.changePasswordAt === null) {
    this.changePasswordAt = moment(Date.now()).add('months', 6).toDate();
  };
  if (this.confirmAt === null) {
    this.confirmAt = Date.now();
    this.tempPassword = null;
  };
});

// Public profile information
// UserSchema
//   .virtual('profile')
//   .get(function() {
//     return {
//       'name': this.profile.firstName+' '+tihs.profile.lastName,
//       'description': this.profile.description,
//       'phone': this.profile.phoneNumber,
//       'role': this.role
//     };
//   });

/**
 * Validations
 */

// Validate empty email
UserSchema.path('email').validate(function(email) {
    // if you are authenticating by any of the oauth strategies, don't validate
    if (authTypes.indexOf(this.provider) !== -1) return true;
    return email.length;
  }, 'Email cannot be blank');

// Validate empty password
UserSchema.path('hashedPassword').validate(function(hashedPassword) {
    // if you are authenticating by any of the oauth strategies, don't validate
    if (authTypes.indexOf(this.provider) !== -1 || this.confirmAt === null) return true;
    return hashedPassword.length;
  }, 'Password cannot be blank');

// Validate email is not taken
UserSchema.path('email').validate(function(value, respond) {
    var self = this;
    this.constructor.findOne({email: value}, function(err, user) {
      if(err) throw err;
      if(user) {
        if(self.id === user.id) return respond(true);
        return respond(false);
      }
      respond(true);
    });
}, 'The specified email address is already in use.');

var validatePresenceOf = function(value) {
  return value && value.length;
};

/**
 * Pre-save hook
 */
UserSchema
  .pre('save', function(next) {

    if (this.isNew) {
      var _tempPassword = this._id.toString().substr(0,8);
      this.password = _tempPassword;
      this.tempPassword = _tempPassword;
    };

    if (!this.isNew) {
      jobs.create('CreateLog', {
        user: this.updatedBy,
        action: 'update',
        _class: this.constructor.modelName,
        _classId: this._id,
        data: this
      })
      .priority('normal')
      .save();
    }

    if (!this.isNew) return next();

    if (!this.isNew && !validatePresenceOf(this.hashedPassword) && authTypes.indexOf(this.provider) === -1)
      next(new Error('Invalid password'));
    else
      next();
  });

UserSchema.post('save', function(next) {
  if (!this.sendEmailNewUser) {
    var self = this;
    // CORREO DE BIENVENIDA
    jobs.create('sendEmail', this.newUser).priority('high').save();

    // LOG DE LA CREACION DEL USUARIO
    jobs.create('CreateLog', {
      user: this.createdBy,
      action: 'create.'+this.role.toLowerCase(),
      _class: this.constructor.modelName,
      _classId: this._id,
      data: this
    })
    .priority('normal')
    .save();
  };
});

UserSchema.static('getInfo', function(id, cb) {

  this.findById(id, function(err, user) {
    if (!err) {

      return cb(null, user.userInfo);

    } else {
      cb('Error al buscar la info del usuario');
    };
  });

});

/**
 * Methods
 */
UserSchema.methods = {
  block: function(cb) {
    this._blocked = true;
    this.changePasswordAt = null;
    this.save(function(err) {
      if (err) return cb(err);
      return cb();
    });
  },
  recovery: function(cb) {
    var _tempPassword = this._id.toString().substr(0,8);
    this.password = _tempPassword;
    this.tempPassword = _tempPassword;
    this.confirmAt = null;
    var self = this;
    this.save(function(err){
      if (err) return cb(err);
      // CREAR EMAIL
      jobs.create('sendEmail', self.recoveryEmail).priority('high').save();
      cb(null, self);
    });
  },
  /**
   * Authenticate - check if the passwords are the same
   *
   * @param {String} plainText
   * @return {Boolean}
   * @api public
   */
  authenticate: function(plainText) {
    return this.encryptPassword(plainText) === this.hashedPassword;
  },

  /**
   * Make salt
   *
   * @return {String}
   * @api public
   */
  makeSalt: function() {
    return crypto.randomBytes(16).toString('base64');
  },

  /**
   * Encrypt password
   *
   * @param {String} password
   * @return {String}
   * @api public
   */
  encryptPassword: function(password) {
    if (!password || !this.salt) return '';
    var salt = new Buffer(this.salt, 'base64');
    return crypto.pbkdf2Sync(password, salt, 10000, 64).toString('base64');
  }
};

module.exports = mongoose.model('User', UserSchema);
