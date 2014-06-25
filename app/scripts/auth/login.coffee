'use strict'

angular.module('auth_app')
  .controller 'LoginCtrl', ($rootScope, $scope, Auth, $state, $window) ->
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
          console.log $rootScope.currentUser.confirmAt
          if !$rootScope.currentUser.confirmAt
            $state.transitionTo "change"
          else
            # Logged in, redirect to home
            $window.location = '/'
        .catch (err) ->
          err = err.data;
          $scope.errors.other = err;
