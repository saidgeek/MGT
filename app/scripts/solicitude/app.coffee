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
      .state 'solicitude',
        url: '/solicitud/:id'
        templateUrl: 'partials/solicitude/Detail'
        resolve:
          _solicitude: (Solicitude, $stateParams) =>
            Solicitude.show $stateParams.id, (err, solicitude) ->
              if !err
                return solicitude
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
