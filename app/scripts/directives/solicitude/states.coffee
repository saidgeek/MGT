'use strict'

angular.module('movistarApp')
  .directive 'sgkStatesFilter', ($window, $rootScope, $timeout) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'partials/solicitude/filters/states'
    controller: ($scope, $rootScope, SolicitudeFactory) ->
      $scope.states = $rootScope.currentUser.permissions.states
      $scope.groups = null

      $scope.reload = () =>
        SolicitudeFactory.groups (err, groups) ->
          if !err
            $scope.groups = groups.states

      $rootScope.$on 'reloadStateFilter', (e) =>
        $scope.reload()
      
      $scope.reload()