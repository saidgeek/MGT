'use strict'

angular.module('movistarApp')
  .controller 'CssCtrl', ($rootScope, $scope, $location) ->
    $rootScope.$watch 'cssInclude', () ->
      $scope.includeCss = $rootScope.cssInclude

    $scope.isActive = (path) ->
      path is $location.$$path