'use strict'

angular.module('movistarApp')
  .controller 'FilterCtrl', ($scope, $rootScope, Solicitude, PriorityIconData, PriorityData, Category, IO) ->
    $scope.states = $rootScope.currentUser.permissions.states
    $scope.priorityIcons = PriorityIconData.getAll()
    $scope.priorities = PriorityData.getArray()
    $scope.categories = null
    $scope.groups = null

    Solicitude.groups (err, groups) ->
        if !err
          $scope.groups = groups

    IO.on 'solicitude.new', (data) ->    
      Solicitude.groups (err, groups) ->
        if !err
          $scope.groups = groups

    Category.index (err, categories) ->
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