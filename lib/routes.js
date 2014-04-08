'use strict';

var api = require('./controllers/api'),
    index = require('./controllers'),
    session = require('./controllers/session');

// api v1 controllers
var users = require('./controllers/api/v1/users');
var solicitude = require('./controllers/api/v1/solicitude');
var category = require('./controllers/api/v1/category');

var middleware = require('./middleware');

/**
 * Application routes
 */
module.exports = function(app) {

  // Server API Routes
  // API Users
  app.get('/api/v1/users', middleware.authenticateToken, users.list);
  app.get('/api/v1/users/groups', middleware.authenticateToken, users.groups);
  app.post('/api/v1/user', middleware.authenticateToken, users.create);
  app.get('/api/v1/user/:id', middleware.authenticateToken, users.show);
  app.put('/api/v1/user/:id/update/profile', middleware.authenticateToken, users.updateProfile);
  app.del('/api/v1/user/:id', middleware.authenticateToken, users.delete);
  app.put('/api/v1/user/:id/change/password', middleware.authenticateToken, users.changePassword);
  app.get('/api/v1/user/me', middleware.authenticateToken, users.me);
  app.put('/api/v1/user/recovery', users.recovery);

  //API Solicitudes
  app.get('/api/v1/solicitudes', middleware.authenticateToken, solicitude.list);
  app.post('/api/v1/solicitude', middleware.authenticateToken, solicitude.create);
  app.get('/api/v1/solicitude/:id', middleware.authenticateToken, solicitude.show);
  app.put('/api/v1/solicitude/:id', middleware.authenticateToken, solicitude.update);
  app.put('/api/v1/solicitude/:id/add/tasks', middleware.authenticateToken, solicitude.addTasks);
  app.put('/api/v1/solicitude/:id/add/comments', middleware.authenticateToken, solicitude.addComments);
  app.put('/api/v1/solicitude/:id/change/state', middleware.authenticateToken, solicitude.changeState);

  //API Categories
  app.get('/api/v1/categories', middleware.authenticateToken, category.list);
  app.post('/api/v1/category', middleware.authenticateToken, category.create);
  app.get('/api/v1/category/:id', middleware.authenticateToken, category.show);
  app.put('/api/v1/category/:id', middleware.authenticateToken, category.update);
  app.del('/api/v1/category/:id', middleware.authenticateToken, category.remove);


  // Sessions
  app.post('/session', function(req, res, next) {
      if (req.query.remember) {
        req.session.cookie.maxAge = 2592000000;
      }
      else {
        req.session.cookie.expires = false;
      }
      return next();
    },session.login);
  app.del('/session', session.logout);

  // All undefined api routes should return a 404
  app.get('/api/*', function(req, res) {
    res.send(404);
  });
  // All other routes to use Angular routing in app/scripts/app.js
  app.get('/partials/*', index.partials);
  app.get('/*', middleware.setUserCookie, index.index);
};
