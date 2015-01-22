'use strict'

mongoose = require 'mongoose'
path = require 'path'
config = require './lib/config/config'
mongoose.connect config.mongo.uri, config.mongo.options
modelsPath = path.join __dirname, './lib/models'

require './lib/models/email'
require './lib/models/token'
require './lib/models/user'
require './lib/models/attachment'
require './lib/models/category'
require './lib/models/notification'
require './lib/models/solicitude'
require './lib/models/task'
require './lib/models/comment'
require './lib/models/log'


Solicitude = mongoose.model 'Solicitude'

schema =
	archivedAt:
		ROOT: null
		ADMIN: null
		EDITOR: null
		CLIENT: null
		CONTENT_MANAGER: null
		PROVIDER: null


Solicitude.update({}, schema, { multi: true, overwrite: true }).exec();
