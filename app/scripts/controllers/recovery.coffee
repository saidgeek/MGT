'use strict';

angular.module('movistarApp')
  .controller 'RecoveryCtrl', ($scope, Auth, $location) ->
    $scope.user = {}
    $scope.errors = {}
    $scope.success = {}

    $scope.recovery = (form) ->
      $scope.submitted = true

      if form.$valid
        Auth.recovery(
          email: $scope.user.email
        )
        .then (user)->
          $scope.success.sendEmail = true
          $scope.success.email = user.email
        .catch (err) ->
          err = err.data
          $scope.errors.other = err