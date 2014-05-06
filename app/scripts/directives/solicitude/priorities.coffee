'use strict'

angular.module('movistarApp')
  .directive 'sgkPrioritiesFilter', ($window, $rootScope, $timeout) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'partials/solicitude/filters/priorities'
    controller: ($scope, $rootScope, SolicitudeFactory, PriorityIconData, PriorityData) ->
      $scope.priorityIcons = PriorityIconData.getAll()
      $scope.priorities = PriorityData.getArray()
      $scope.groups = null

      $scope.reload = () =>
        SolicitudeFactory.groups (err, groups) ->
          if !err
            $scope.groups = groups.priorities

      $rootScope.$on 'reloadPriorityFilter', (e) =>
        $scope.reload()
      
      $scope.reload()