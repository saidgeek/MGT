'use strict'

angular.module('movistarApp')
  .directive 'sgkUserStatesFilter', ($window, $rootScope, $timeout) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'directives/user/states'
    controller: ($scope, $rootScope, SolicitudeFactory) ->
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

      $scope.reload = () =>
        SolicitudeFactory.groups (err, groups) ->
          if !err
            $scope.groups = groups.states

      $rootScope.$on 'reloadStateFilter', (e) =>
        $scope.reload()
      
      $scope.reload()