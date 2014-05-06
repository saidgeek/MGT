'use strict'

angular.module('movistarApp')
  .directive 'sgkInvolvedFilter', ($window, $rootScope, $timeout) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'partials/solicitude/filters/involved'
    controller: ($scope, $rootScope, UserFactory) ->
      $scope.users = null

      UserFactory.index '', (err, users) ->
        if !err
          $scope.users = users