'use strict'

angular.module('movistarApp')
  .controller 'CssCtrl', ($rootScope, $scope) ->
    $rootScope.$watch 'cssInclude', () ->
      $scope.includeCss = $rootScope.cssInclude