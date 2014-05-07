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

      $scope.filter = (value) =>
        console.log value
        value = null unless value?
        if $rootScope.filters?.solicitude?.priority?
          $rootScope.filters.solicitude.priority = value
        else
          $rootScope.filters = 
            solicitude:
              priority: value

      $scope.reload = () =>
        SolicitudeFactory.groups (err, groups) ->
          if !err
            $scope.groups = groups.priorities
            console.log $scope.groups

      $rootScope.$on 'reloadPriorityFilter', (e) =>
        $scope.reload()
      
      $scope.reload()