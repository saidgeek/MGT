'use strict'

angular.module('movistarApp')
  .directive 'sgkPrioritiesFilter', ($window, $rootScope, $timeout) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'partials/solicitude/filters/priorities'
    controller: ($scope, $rootScope, Solicitude, PriorityIconData, PriorityData) ->
      $scope.priorityIcons = PriorityIconData.getAll()
      $scope.priorities = PriorityData.getArray()
      $scope.groups = null

      $scope.filter = (value) =>
        value = null unless value?
        if $rootScope.filters?.solicitude?.priority?
          $rootScope.filters.solicitude.priority = value
        else
          $rootScope.filters = 
            solicitude:
              priority: value

      $scope.reload = () =>
        Solicitude.groups (err, groups) ->
          if !err
            $scope.groups = groups.priorities

      $rootScope.$on 'reloadPriorityFilter', (e) =>
        $scope.reload()
      
      $scope.reload()