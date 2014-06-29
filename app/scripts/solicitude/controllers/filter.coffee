'use strict'

angular.module('movistarApp')
  .controller 'FilterCtrl', ($scope, $rootScope, Solicitude, PriorityIconData, PriorityData, CategoryFactory) ->
    $scope.states = $rootScope.currentUser.permissions.states
    $scope.priorityIcons = PriorityIconData.getAll()
    $scope.priorities = PriorityData.getArray()
    $scope.categories = null
    $scope.groups = null

    Solicitude.groups (err, groups) ->
        if !err
          $scope.groups = groups

    CategoryFactory.index (err, categories) ->
      if !err
        $scope.categories = categories

    $scope.filter = (value) =>
      value = null unless value?
      if $rootScope.filters?.solicitude?.state?
        $rootScope.filters.solicitude.state = value
      else
        $rootScope.filters = 
          solicitude:
            state: value