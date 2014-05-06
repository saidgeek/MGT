'use strict'

angular.module('movistarApp')
  .directive 'sgkStatesFilter', ($window, $rootScope, $timeout) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'partials/solicitude/filters/states'
    controller: ($scope, $rootScope, SolicitudeFactory) ->
      $scope.states = $rootScope.currentUser.permissions.states
      $scope.groups = null

      $scope.filter = (value) =>
        value = null unless value?
        if $rootScope.filters?.solicitude?.state?
          $rootScope.filters.solicitude.state = value
        else
          $rootScope.filters = 
            solicitude:
              state: value

      $scope.reload = () =>
        SolicitudeFactory.groups (err, groups) ->
          if !err
            $scope.groups = groups.states

      $rootScope.$on 'reloadStateFilter', (e) =>
        $scope.reload()
      
      $scope.reload()