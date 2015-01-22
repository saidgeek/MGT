'use strict';

var index = require('./controllers'),
    session = require('./controllers/session');

// api v1 controllers
var users = require('./controllers/api/v1/users');
var solicitude = require('./controllers/api/v1/solicitude');
var comment = require('./controllers/api/v1/comment');
var attachment = require('./controllers/api/v1/attachment');
var task = require('./controllers/api/v1/task');
var category = require('./controllers/api/v1/category');
var notification = require('./controllers/api/v1/notification');
var log = require('./controllers/api/v1/log');

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
  app.get('/api/v1/user/:id/solicitudes', middleware.authenticateToken, users.solicitudes);
  app.put('/api/v1/user/:id/update/profile', middleware.authenticateToken, users.updateProfile);
  app.del('/api/v1/user/:id', middleware.authenticateToken, users.delete);
  app.put('/api/v1/user/:id/change/password', users.changePassword);
  app.get('/api/v1/user/me', middleware.authenticateToken, users.me);
  app.put('/api/v1/user/recovery', users.recovery);

  //API Solicitudes
  app.get('/api/v1/solicitudes', middleware.authenticateToken, solicitude.list);
  app.get('/api/v1/solicitudes/archived', middleware.authenticateToken, solicitude.list_archived);
  app.get('/api/v1/solicitudes/search/:q', middleware.authenticateToken, solicitude.search);
  app.get('/api/v1/solicitudes/:target/:filter', middleware.authenticateToken, solicitude.list);
  app.get('/api/v1/solicitudes/groups', middleware.authenticateToken, solicitude.groups);
  app.post('/api/v1/solicitude/:client_id', middleware.authenticateToken, solicitude.create);
  app.get('/api/v1/solicitude/:id', middleware.authenticateToken, solicitude.show);
  app.put('/api/v1/solicitude/:id', middleware.authenticateToken, solicitude.update);
  app.put('/api/v1/solicitude/:id/add/tasks', middleware.authenticateToken, solicitude.addTasks);
  app.put('/api/v1/solicitude/:id/check/:task', middleware.authenticateToken, solicitude.toggleCheckTask);
  app.put('/api/v1/solicitude/:id/add/comments', middleware.authenticateToken, solicitude.addComments);
  app.put('/api/v1/solicitude/:id/change/state', middleware.authenticateToken, solicitude.changeState);
  app.put('/api/v1/solicitude/:id/archived', middleware.authenticateToken, solicitude.archived);
  app.del('/api/v1/solicitude/:id/delete', middleware.authenticateToken, solicitude.delete);

  //API Comments
  app.get('/api/v1/comments/:solicitude_id', middleware.authenticateToken, comment.index);
  app.get('/api/v1/comments/:solicitude_id/comments/:type', middleware.authenticateToken, comment.index_type);
  app.get('/api/v1/comment/:id', middleware.authenticateToken, comment.show);
  app.get('/api/v1/comments/task/:id', middleware.authenticateToken, comment.index_task);
  app.post('/api/v1/comments/:solicitude_id/:task_id', middleware.authenticateToken, comment.task);
  app.post('/api/v1/comments/:type/:solicitude_id/:to', middleware.authenticateToken, comment.create);

  //API task
  app.get('/api/v1/tasks/:solicitude_id', middleware.authenticateToken, task.index);
  app.get('/api/v1/task/:id', middleware.authenticateToken, task.show);
  app.post('/api/v1/tasks/:solicitude_id', middleware.authenticateToken, task.create);
  app.put('/api/v1/tasks/:id', middleware.authenticateToken, task.toggleCompleted);

  //API Attachments
  app.get('/api/v1/attachments/:solicitude_id', middleware.authenticateToken, attachment.index);

  //API Categories
  app.get('/api/v1/categories', middleware.authenticateToken, category.list);
  app.post('/api/v1/category', middleware.authenticateToken, category.create);
  app.get('/api/v1/category/:id', middleware.authenticateToken, category.show);
  app.put('/api/v1/category/:id', middleware.authenticateToken, category.update);
  app.del('/api/v1/category/:id', middleware.authenticateToken, category.remove);

  app.get('/api/v1/log/:user_id/excel', log.excel);
  app.get('/api/v1/log/:user_id/csv', log.csv);

  // API Notifications
  app.get('/api/v1/notifications', middleware.authenticateToken, notification.index);
  app.put('/api/v1/notifications/read_all', middleware.authenticateToken, notification.read_all);
  app.put('/api/v1/notifications/:id', middleware.authenticateToken, notification.read);

  app.get('/api/v1/filepicker/key', middleware.authenticateToken, function (req, res) {
    return res.json(200, { key: global.filepicker });
  });

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
  app.get('/directives/*', index.directives);
  app.get('/auth/*', middleware.setUserCookie, index.auth);
  app.get('/admin/*', middleware.setUserCookie, index.admin);
  app.get('/*', middleware.setUserCookie, index.index);
};
