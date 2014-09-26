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

    $urlRouterProvider.otherwise '/admin/users'

    $stateProvider
      # ADIMIN.USERS ROUTE
      .state 'users',
        url: '/admin/users'
        views:
          'sidebox':
            templateUrl: 'partials/user/sidebox'
          'sidebar':
            templateUrl: 'partials/user/sidebar'
            controller: 'UsersGroupsCtrl'
          'left':
            templateUrl: 'partials/user/left'
            controller: 'UserCtrl'
          'right':
            templateUrl: 'partials/user/right'
            controller: 'UserShowCtrl'
        resolve:
          _users_groups: (User) =>
            User.resource.groups({ roles: null }).$promise
          _users: (User) =>
            User.resource.index({ role: null }).$promise
          _user: (User, _users) =>
            User.resource.show({ id: _users[0]._id }).$promise
          _user_solicitudes: (User, _user) =>
            User.resource.solicitudes({ id: _user._id, role: _user.role, state: null }).$promise
        authenticate: true

      .state 'users_role',
        url: '/admin/users/:role'
        views:
          'sidebox':
            templateUrl: 'partials/user/sidebox'
          'sidebar':
            templateUrl: 'partials/user/sidebar'
            controller: 'UsersGroupsCtrl'
          'left':
            templateUrl: 'partials/user/left'
            controller: 'UserCtrl'
          'right':
            templateUrl: 'partials/user/right'
            controller: 'UserShowCtrl'
        resolve:
          _users_groups: (User) =>
            User.resource.groups({ roles: null }).$promise
          _users: (User, $stateParams) =>
            User.resource.index({ role: $stateParams.role.toUpperCase() }).$promise
          _user: (User, _users) =>
            User.resource.show({ id: _users[0]._id }).$promise
          _user_solicitudes: (User, _user) =>
            User.resource.solicitudes({ id: _user._id, role: _user.role, state: null }).$promise
        authenticate: true

      .state 'users_show',
        url: '/admin/users/:id'
        views:
          'sidebox':
            templateUrl: 'partials/user/sidebox'
          'sidebar':
            templateUrl: 'partials/user/sidebar'
            controller: 'UsersGroupsCtrl'
          'left':
            templateUrl: 'partials/user/left'
            controller: 'UserCtrl'
          'right':
            templateUrl: 'partials/user/right'
            controller: 'UserShowCtrl'
        resolve:
          _users_groups: (User) =>
            User.resource.groups({ roles: null }).$promise
          _users: (User) =>
            User.resource.index({ role: null }).$promise
          _user: (User, $stateParams) =>
            User.resource.show({ id: $stateParams.id }).$promise
          _user_solicitudes: (User, _user) =>
            User.resource.solicitudes({ id: _user._id, role: _user.role, state: null }).$promise
        authenticate: true

      .state 'users_solicitudes_filter',
        url: '/admin/users/:id/:role/:state'
        views:
          'sidebox':
            templateUrl: 'partials/user/sidebox'
          'sidebar':
            templateUrl: 'partials/user/sidebar'
            controller: 'UsersGroupsCtrl'
          'left':
            templateUrl: 'partials/user/left'
            controller: 'UserCtrl'
          'right':
            templateUrl: 'partials/user/right'
            controller: 'UserShowCtrl'
        resolve:
          _users_groups: (User) =>
            User.resource.groups({ roles: null }).$promise
          _users: (User) =>
            User.resource.index({ role: null }).$promise
          _user: (User, $stateParams) =>
            User.resource.show({ id: $stateParams.id }).$promise
          _user_solicitudes: (User, $stateParams) =>
            User.resource.solicitudes({ id: $stateParams.id, role: $stateParams.role, state: $stateParams.state }).$promise
        authenticate: true

      # ADIMIN.CATEGORY ROUTE
      .state 'categories',
        url: '/admin/categories',
        views:
          'sidebox':
            templateUrl: 'partials/category/sidebox'
          'left':
            templateUrl: 'partials/category/left'
          'right':
            templateUrl: 'partials/category/right'
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

  .run ($rootScope, $state, Auth, $timeout, $window, $http) ->
    $http.defaults.headers.common['token-client'] =  $rootScope.currentUser.access.clientToken
    $http.defaults.headers.common['token-access'] =  $rootScope.currentUser.access.accessToken

    # Redirect to login if route requires auth and you're not logged in
    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromParams) ->
      if toState.authenticate and not Auth.isLoggedIn()
        $window.location = "/auth/login"
        event.preventDefault()
      $rootScope.filters = null

    # stateChangeSuccess
    $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromParams) ->
      angular.element('body')
        .find('#loading')
        .fadeOut 500
