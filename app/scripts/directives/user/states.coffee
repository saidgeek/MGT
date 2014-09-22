'use strict'

angular.module('movistarApp')
  .directive 'sgkUserStatesFilter', ($window, $rootScope, $timeout, Solicitude) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'directives/user/states'
    controller: ($scope, $rootScope) ->
      $scope.states = $rootScope.currentUser.permissions.states
      $scope.groups = null

      $scope.filter = (value) =>
        value = null unless value?
        if $rootScope.filters?.solicitude?.state?
          $rootScope.filters.user.solicitude.state = value
        else
          $rootScope.filters =
            user:
              solicitude:
                state: value

    link: (scope, element, attrs) =>
      user_id = attrs.sgkUserId
      role = attrs.sgkRole

      Solicitude.groupsForUser user_id, role, (err, groups) =>
        if !err
          scope.groups = groups.states
