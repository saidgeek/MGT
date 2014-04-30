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
      # ACCESS ROUTERS
      .state 'login',
        url: '/login'
        controller: 'LoginCtrl'
        templateUrl: 'partials/login'
        authenticate: false
      .state 'recovery',
        url: '/recovery'
        controller: 'RecoveryCtrl'
        templateUrl: 'partials/recovery'
        authenticate: false
      .state 'change.password',
        url: '/change/password'
        controller: 'ChangeCtrl'
        templateUrl: 'partials/change'
        authenticate: true

      # ADMIN ROUTERS
      .state 'admin',
        url: '/admin',
        contorller: 'AdminCtrl'
        templateUrl: 'partials/admin/main'
        authenticate: true
      .state 'admin.module',
        url: '/:module'
        controller: 'AdminCtrl'
        templarteUrl: 'partials/admin/main'
        authenticate: true

      # SOLICITUDE ROUTERS
      .state 'solicitude',
        url: '/'
        controller: 'SolicitudeCtrl'
        templateUrl: 'partials/solicitude/main'
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
  .factory 'noCacheInterceptor', () ->
    request: (config) ->
      if config.method is 'GET' and config.url.indexOf('partials/') is -1
        separator = '&'
        if config.url.indexOf('?') is -1
          separator = '?'
        config.url = config.url+separator+'noCache=' + new Date().getTime()
      return config;
  .run ($rootScope, $state, Auth) ->

    # Redirect to login if route requires auth and you're not logged in
    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromParams) ->
      console.log toState, toState.authenticate, Auth.isLoggedIn()
      if toState.authenticate and not Auth.isLoggedIn()
        $state.transitionTo "login"
        event.preventDefault()
