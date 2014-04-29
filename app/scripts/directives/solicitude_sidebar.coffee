'use strict'

angular.module('movistarApp')
  .directive 'sgkSolicitudeSidebar', ($window, $rootScope, $timeout, AllStateData, StateData, PriorityData, PriorityIconData, CategoryFactory, UserFactory) ->
    restrict: 'A'
    templateUrl: 'partials/solicitude/solicitudeSidebar'
    controller: ($scope, $element) ->
      $scope.allStates = AllStateData.getAll()
      console.log 'allStates:', $scope.allStates
      $scope.states = StateData.getArray()
      $scope.priorityIcons = PriorityIconData.getAll()
      $scope.categories = null
      $scope.users = null

      $scope.priorities = PriorityData.getArray()

      CategoryFactory.index (err, categories) ->
        if err
          $scope.errors = err
        else
          $scope.categories = categories

      UserFactory.index '', (err, users) ->
        if err
          $scope.errors = err
        else
          $scope.users = users

      $scope.$watch 'groups', (value) ->
        $rootScope.resize = true
        $timeout () =>
          $timeout () =>
            $timeout () =>
              if $element.find('.overflow .mCustomScrollBox').length is 0
                $element.find('.overflow').mCustomScrollbar
                  scrollButtons:
                      enable:false
              $element.find('.overflow').mCustomScrollbar "update"
              $element.find('.overflow').mCustomScrollbar "scrollTo", "top"
            , 1000
          , 0
        , 0
