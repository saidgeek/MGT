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
      .state 'change',
        url: '/change/password'
        controller: 'ChangeCtrl'
        templateUrl: 'partials/change'
        authenticate: true

      # ADMIN ROUTERS
      .state 'admin',
        templateUrl: 'partials/layout'
        authenticate: true
      # ADIMIN.USERS ROUTE
      .state 'admin.users',
        url: '/admin/users'
        views:
          'sidebox': 
            templateUrl: 'partials/user/sidebox'
          'sidebar':
            templateUrl: 'partials/user/sidebar'
          'left':
            templateUrl: 'partials/user/left'
          'right':
            templateUrl: 'partials/user/right'
        authenticate: true
      # ADIMIN.CATEGORY ROUTE
      .state 'admin.categories',
        url: '/admin/categories',
        views:
          'sidebox': 
            templateUrl: 'partials/category/sidebox'
          'left':
            templateUrl: 'partials/category/left'
          'right':
            templateUrl: 'partials/category/right'
        authenticate: true

      # SOLICITUDE ROUTERS
      .state 'solicitude',
        templateUrl: 'partials/layout'
        authenticate: true
      .state 'solicitude.index',
        url: '/'
        views:
          'sidebox': 
            templateUrl: 'partials/solicitude/sidebox'
          'sidebar':
            templateUrl: 'partials/solicitude/sidebar'
          'left':
            templateUrl: 'partials/solicitude/left'
          'right':
            templateUrl: 'partials/solicitude/right'
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
  .run ($rootScope, $state, Auth) ->

    # Redirect to login if route requires auth and you're not logged in
    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromParams) ->
      if toState.authenticate and not Auth.isLoggedIn()
        $state.transitionTo "login"
        event.preventDefault()
      $rootScope.filters = null

