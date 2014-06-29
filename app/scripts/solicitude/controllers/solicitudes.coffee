'use strict'

angular.module('movistarApp')
  .controller 'SolicitudesCtrl', ($scope, $rootScope, IO, Solicitude, $state, _solicitudes) ->
    $scope.solicitudes = _solicitudes
    $scope.role = $rootScope.currentUser.role
    _target = null
    _filter = null
    
    IO.on 'solicitude.new', (data) ->
      Solicitude.show data.id, (err, solicitude) ->
        if !err
          $scope.solicitudes.unshift solicitude

    # Solicitude.index _target, _filter, (err, solicitudes) ->
    #   if err
    #     $scope.errors = err
    #   else
    #     if solicitudes.length > 0
    #       $scope.solicitudes = solicitudes
    #       console.log '$scope.solicitudes:', $scope.solicitudes
    #     else
    #       $scope.solicitudes = null
