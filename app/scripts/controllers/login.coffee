'use strict'

angular.module('movistarApp')
  .controller 'LoginCtrl', ($rootScope, $scope, Auth, $location) ->
    $rootScope.cssInclude = ['styles/auth.css']
    $rootScope.title = "Ingreso a Herramienta Tareas Movistar"
    $scope.user = {}
    $scope.errors = {}

    $scope.login = (form) ->
      $scope.submitted = true

      if form.$valid
        Auth.login(
          email: $scope.user.email
          password: $scope.user.password
          remember: $scope.user.remember
        )
        .then ->
          # Logged in, redirect to home
          $location.path '/'
        .catch (err) ->
          err = err.data;
          $scope.errors.other = err;
