'use strict'

angular.module('movistarApp')
  .controller 'ChangeCtrl', ($rootScope, $scope, Auth, $location) ->
    $scope.user = {}
    $scope.errors = {}

    $scope.change = (form) ->
      $scope.submitted = true
      if form.$valid
        Auth.changePassword(
          oldPassword: $scope.user.oldPassword
          newPassword: $scope.user.newPassword
          confirmPassword: $scope.user.confirmPassword
          id: $rootScope.currentUser.id
        )
        .then ->
          # Logged in, redirect to home
          $location.path '/'
        .catch (err) ->
          err = err.data;
          $scope.errors.other = err;
