'use strict'

angular.module('movistarApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'filepicker'
])
  .config ($routeProvider, $locationProvider, $httpProvider) ->
    $routeProvider
      .when '/login',
        templateUrl: 'partials/login'
        controller: 'LoginCtrl'
      .when '/recovery',
        templateUrl: 'partials/recovery'
        controller: 'RecoveryCtrl'

      .when '/admin',
        templateUrl: 'partials/admin/main'
        controller: 'AdminCtrl'
        authenticate: true
      .when '/admin/:module',
        templateUrl: 'partials/admin/main'
        controller: 'AdminCtrl'
        authenticate: true

      .when '/',
        templateUrl: 'partials/dashboard/main'
        controller: 'DashboardCtrl'
        authenticate: true
      .when '/settings',
        templateUrl: 'partials/settings'
        controller: 'SettingsCtrl'
        authenticate: true
      .otherwise
        redirectTo: '/'

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
  .run ($rootScope, $location, Auth) ->

    # Redirect to login if route requires auth and you're not logged in
    $rootScope.$on '$routeChangeStart', (event, next) ->
      $location.path '/login'  if next.authenticate and not Auth.isLoggedIn()
