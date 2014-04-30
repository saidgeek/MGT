'use strict'

angular.module('movistarApp')
  .controller 'LoginCtrl', ($rootScope, $scope, Auth, $state) ->
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
          if !$rootScope.currentUser.confirmAt
            $state.transitionTo "change.password"
          else
            # Logged in, redirect to home
            $state.transitionTo 'solicitude'
        .catch (err) ->
          err = err.data;
          $scope.errors.other = err;
