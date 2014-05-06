'use strict'

angular.module('movistarApp')
  .directive 'sgkInvolvedFilter', ($window, $rootScope, $timeout) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'partials/solicitude/filters/involved'
    controller: ($scope, $rootScope, UserFactory) ->
      $scope.users = null

      $scope.filter = (value) =>
        value = null unless value?
        if $rootScope.filters?.solicitude?.involved?
          $rootScope.filters.solicitude.involved = value
        else
          $rootScope.filters = 
            solicitude:
              involved: value

      UserFactory.index '', (err, users) ->
        if !err
          $scope.users = users