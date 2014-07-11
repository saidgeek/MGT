'use strict'

angular.module('movistarApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ui.router',
  'filepicker',
  'confirmClick',
  'btford.socket-io'
])
  .config ($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider) ->
    $httpProvider.interceptors.push 'noCacheInterceptor'

    $urlRouterProvider.otherwise '/'

    $stateProvider
      # SOLICITUDE ROUTERS
      .state 'solicitudes',
        url: '/'
        templateUrl: 'partials/solicitude/index'
        resolve:
          _solicitudes: (Solicitude) =>
            Solicitude.resource.index({ target: null, filter: null }).$promise
        controller: 'SolicitudesCtrl'
        authenticate: true
      .state 'filter',
        url: '/solicitudes/:target/:filter'
        templateUrl: 'partials/solicitude/index'
        resolve:
          _solicitudes: (Solicitude, $stateParams) =>
            Solicitude.resource.index({ target: $stateParams.target, filter: $stateParams.filter }).$promise
        controller: 'SolicitudesCtrl'
        authenticate: true
      .state 'search',
        url: '/solicitudes/search/:q'
        templateUrl: 'partials/solicitude/index'
        resolve:
          _solicitudes: (Solicitude, $stateParams) =>
            Solicitude.resource.search({ q: $stateParams.q }).$promise
        controller: 'SolicitudesCtrl'
        authenticate: true
      .state 'solicitude',
        url: '/solicitud/:id'
        templateUrl: 'partials/solicitude/detail'
        resolve:
          _solicitude: (Solicitude, $stateParams) =>
            Solicitude.show $stateParams.id, (err, solicitude) ->
              if !err
                return solicitude
          _attachments: (Attachment, $stateParams) =>
            Attachment.index $stateParams.id, (err, attachments) ->
              if !err
                return attachments
          _comments: (Comment, $stateParams) =>
            Comment.index $stateParams.id, (err, comments) ->
              if !err
                return comments
          _tasks: (Task, $stateParams) =>
            Task.index $stateParams.id, (err, tasks) ->
              if !err
                return tasks
        controller: 'SolicitudeCtrl'
        authenticate: true

    $locationProvider.html5Mode true

    # Intercept 401s and redirect you to login
    $httpProvider.interceptors.push ['$q', '$location', ($q, $location) ->
      responseError: (response) ->
        if response.status is 401
          $location.path '/login'
          $q.reject response
        else
          $q.reject response
    ]
  .factory 'noCacheInterceptor', () =>
    request: (config) ->
      if config.method is 'GET' and config.url.indexOf('partials/') is -1 and config.url.indexOf('directives/') is -1
        separator = '&'
        if config.url.indexOf('?') is -1
          separator = '?'
        config.url = config.url+separator+'noCache=' + new Date().getTime()
      return config;

  .factory "IO", (socketFactory) ->
    return socketFactory
      ioSocket: io.connect '/'

  .factory 'ActionsFactory', ($http) ->
    return {
      action: (state) ->
        $http.get("/partials/solicitude/actions/#{ state }")
      section: (section) ->
        $http.get("/partials/solicitude/sections/#{ section }")
      permission: (state, role) ->
        return true if ['queue_validation'].indexOf(state) > -1 and ['EDITOR', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['assigned_to_manager'].indexOf(state) > -1 and ['EDITOR', 'CONTENT_MANAGER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['assigned_to_provider'].indexOf(state) > -1 and ['EDITOR', 'PROVIDER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['proccess'].indexOf(state) > -1 and ['EDITOR', 'PROVIDER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['queue_validation_manager'].indexOf(state) > -1 and ['CONTENT_MANAGER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['queue_validation_client'].indexOf(state) > -1 and ['CLIENT', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['accepted_by_client'].indexOf(state) > -1 and ['CONTENT_MANAGER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['queue_publish'].indexOf(state) > -1 and ['PROVIDER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['publish'].indexOf(state) > -1 and ['CONTENT_MANAGER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['rejected_by_client'].indexOf(state) > -1 and ['CONTENT_MANAGER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['rejected_by_manager'].indexOf(state) > -1 and ['PROVIDER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['paused'].indexOf(state) > -1 and ['PROVIDER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['reactivated'].indexOf(state) > -1 and ['PROVIDER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return false
    }

  .factory 'CommentPermissions', ->
    return {
      view: (type, role) ->
        return type is 'Solicitude.pm' and ['ROOT', 'ADMIN', 'EDITOR', 'CONTENT_MANAGER', 'CLIENT'].indexOf(role) > -1
        return type is 'Solicitude.internal' and ['ROOT', 'ADMIN', 'EDITOR', 'CONTENT_MANAGER'].indexOf(role) > -1
        return type is 'Solicitude.provider' and ['ROOT', 'ADMIN', 'EDITOR', 'CONTENT_MANAGER', 'PROVIDER'].indexOf(role) > -1
      send: (type, role) ->
        return type is 'Solicitude.pm' and ['ROOT', 'ADMIN', 'EDITOR', 'CONTENT_MANAGER'].indexOf(role) > -1
        return type is 'Solicitude.internal' and ['ROOT', 'ADMIN', 'EDITOR', 'CONTENT_MANAGER'].indexOf(role) > -1
        return type is 'Solicitude.provider' and ['ROOT', 'ADMIN', 'EDITOR', 'CONTENT_MANAGER'].indexOf(role) > -1
    }

  .run ($rootScope, $state, Auth, $timeout, IO, $window, $http) ->
    $http.defaults.headers.common['token-client'] =  $rootScope.currentUser.access.clientToken
    $http.defaults.headers.common['token-access'] =  $rootScope.currentUser.access.accessToken

    IO.emit 'register.solicitude.globals', 
      id: $rootScope.currentUser?.id || null
    
    # Redirect to login if route requires auth and you're not logged in
    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromParams) ->
      if toState.authenticate and not Auth.isLoggedIn()
        $window.location = "/auth/login"
        event.preventDefault()
      $rootScope.filters = null

    $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromParams) ->
      angular.element('body')
        .find('#loading')
        .fadeOut 500
