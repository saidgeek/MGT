'use strict'

angular.module('movistarApp')
  .controller 'SearchCtrl', ($rootScope, $scope, $state) ->
    $scope.q = null

    $scope.search = (form, type) ->
      if form.$valid
        console.log 'q:', $scope.q.replace /\s/g, '+'
        $state.go 'search', { q: $scope.q.replace /\s/g, '+' }
    