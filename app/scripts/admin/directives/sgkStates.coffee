'use strict'

angular.module('movistarApp')
  .directive 'sgkUserStatesFilter', ($window, $rootScope, $timeout, Solicitude) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'directives/user/states'
    controller: ($scope, $rootScope) ->
      $scope.states = $rootScope.currentUser.permissions.states
      $scope.groups = null

    link: (scope, element, attrs) =>
      scope.user_id = attrs.sgkUserId.toLowerCase()
      scope.role = attrs.sgkRole.toLowerCase()

      Solicitude.groupsForUser scope.user_id, scope.role, (err, groups) =>
        if !err
          scope.groups = groups.states
